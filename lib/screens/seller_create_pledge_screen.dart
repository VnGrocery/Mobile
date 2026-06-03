import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/seller_pledges/controllers/seller_pledge_cubit.dart';
import 'package:vngrocery/features/seller_pledges/controllers/seller_pledge_state.dart';
import 'package:vngrocery/features/seller_pledges/seller_pledge_presenter.dart';
import 'package:vngrocery/features/seller_pledges/widgets/seller_pledge_steps.dart';
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

  final double _aiScore = 8.2;
  final _sellerScore = TextEditingController(text: '8.5');

  @override
  void initState() {
    super.initState();
    _pledgeCubit = SellerPledgeCubit(productId: widget.productId);
  }

  @override
  void dispose() {
    _pledgeCubit.close();
    _sellerScore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _pledgeCubit,
      child: BlocBuilder<SellerPledgeCubit, SellerPledgeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(
              title: Text(SellerPledgePresenter.titleForStep(state.step)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _back(state),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: switch (state.step) {
                1 => SellerPledgeCaptureStep(
                    analyzing: state.analyzing,
                    onCapture: _pledgeCubit.capture,
                  ),
                2 => SellerPledgeEvaluateStep(
                    aiScore: _aiScore,
                    sellerScore: _sellerScore,
                    category: state.category,
                    onCategoryChanged: _pledgeCubit.setCategory,
                    onContinue: _pledgeCubit.continueToConfirm,
                  ),
                _ => SellerPledgeConfirmStep(
                    score: SellerPledgePresenter.normalizedScore(
                      _sellerScore.text,
                    ),
                    loading: state.committing,
                    onCommit: _commit,
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
    await _pledgeCubit.commit(_sellerScore.text);
    if (!mounted) return;
    AppFeedback.showSnackBar(context, 'Đã lưu ghi nhận sản phẩm.');
    Navigator.pop(context);
  }
}
