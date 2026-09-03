import 'dart:typed_data';
import 'package:vngrocery/screens/camera_capture_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/seller_pledges/controllers/seller_pledge_cubit.dart';
import 'package:vngrocery/features/seller_pledges/controllers/seller_pledge_state.dart';
import 'package:vngrocery/features/seller_pledges/seller_pledge_presenter.dart';
import 'package:vngrocery/features/seller_pledges/widgets/seller_pledge_steps.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerCreatePledgeScreen extends StatefulWidget {
  final String productId;

  const SellerCreatePledgeScreen({super.key, required this.productId});

  @override
  State<SellerCreatePledgeScreen> createState() =>
      _SellerCreatePledgeScreenState();
}

class _SellerCreatePledgeScreenState extends State<SellerCreatePledgeScreen> {
  late final SellerPledgeCubit _pledgeCubit;

  // Starts empty. It used to be prefilled with 8.5, so a seller who tapped
  // straight through recorded a score they never gave.
  final _sellerScore = TextEditingController();

  /// Why this score. The server hashes it into the pledge and anchors it, so
  /// it is refused when empty.
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pledgeCubit = SellerPledgeCubit(productId: widget.productId);
  }

  @override
  void dispose() {
    _pledgeCubit.close();
    _sellerScore.dispose();
    _note.dispose();
    super.dispose();
  }

  /// Opens the camera and scores whatever the seller actually photographed.
  Future<void> _capturePhoto() async {
    final l10n = AppLocalizations.of(context);
    final photo = await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(
        builder: (_) => CameraCaptureScreen(hint: l10n.pledgeCaptureHint),
      ),
    );
    if (photo == null || !mounted) return;
    await _pledgeCubit.capture(photo);
    // Offer the model's reading as the starting point - a real number, not an
    // invented one - and only while the seller has not typed their own.
    if (!mounted || _sellerScore.text.isNotEmpty) return;
    final state = _pledgeCubit.state;
    if (state.hasAiScore) _sellerScore.text = '${state.aiScore}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider.value(
      value: _pledgeCubit,
      child: BlocBuilder<SellerPledgeCubit, SellerPledgeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(
              title: Text(SellerPledgePresenter.titleForStep(state.step, l10n)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: l10n.a11yBack,
                onPressed: () => _back(state),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: switch (state.step) {
                1 => SellerPledgeCaptureStep(
                  analyzing: state.analyzing,
                  failure: SellerPledgePresenter.captureFailureMessage(
                    state.failure,
                    l10n,
                  ),
                  onCapture: _capturePhoto,
                ),
                2 => SellerPledgeEvaluateStep(
                  aiScore: state.aiScore,
                  hasAiScore: state.hasAiScore,
                  sellerScore: _sellerScore,
                  category: state.category,
                  onCategoryChanged: _pledgeCubit.setCategory,
                  onScoreChanged: (_) => setState(() {}),
                  onContinue:
                      SellerPledgePresenter.isValidScore(_sellerScore.text)
                      ? _pledgeCubit.continueToConfirm
                      : null,
                ),
                _ => SellerPledgeConfirmStep(
                  score: SellerPledgePresenter.normalizedScore(
                    _sellerScore.text,
                  ),
                  loading: state.committing,
                  note: _note,
                  onNoteChanged: (_) => setState(() {}),
                  onCommit: _note.text.trim().length >= 5 ? _commit : null,
                ),
              },
            ),
          );
        },
      ),
    );
  }

  void _back(SellerPledgeState state) {
    if (state.step > 1) {
      _pledgeCubit.back();
      return;
    }
    Navigator.pop(context);
  }

  Future<void> _commit() async {
    final l10n = AppLocalizations.of(context);
    final String? pledgeId;
    try {
      pledgeId = await _pledgeCubit.commit(
        _sellerScore.text,
        l10n,
        note: _note.text,
      );
    } catch (_) {
      // The screen used to announce a record the server had refused.
      if (!mounted) return;
      AppFeedback.showSnackBar(
        context,
        l10n.sellerPledgeSaveFailed,
        icon: Icons.error_outline,
      );
      return;
    }
    if (!mounted) return;
    AppFeedback.showSnackBar(context, l10n.sellerPledgeSaved);
    if (pledgeId == null) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(
        context,
        Routes.qrLabel,
        arguments: pledgeId,
      );
    }
  }
}
