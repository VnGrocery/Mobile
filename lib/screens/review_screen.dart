import 'dart:typed_data';
import 'package:vngrocery/screens/camera_capture_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/reviews/controllers/review_cubit.dart';
import 'package:vngrocery/features/reviews/controllers/review_state.dart';
import 'package:vngrocery/features/reviews/widgets/review_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

class ReviewScreen extends StatefulWidget {
  final String shopId;

  const ReviewScreen({super.key, required this.shopId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _comment = TextEditingController();
  late final ReviewCubit _reviewCubit;

  @override
  void initState() {
    super.initState();
    _reviewCubit = ReviewCubit(shopId: widget.shopId);
    // One review per shop per account: if this reader already wrote one, the
    // send edits it, and the server refuses an edit that does not name the
    // version it replaces. Loading it supplies that version, and opens the
    // form on the text being replaced instead of on a blank field.
    _reviewCubit.loadExisting().then((comment) {
      if (!mounted || comment == null) return;
      setState(() => _comment.text = comment);
    });
  }

  @override
  void dispose() {
    _reviewCubit.close();
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider.value(
      value: _reviewCubit,
      child: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(title: Text(l10n.reviewTitle)),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const ReviewIntro(),
                  RatingPicker(
                    rating: state.rating,
                    enabled: !state.submitting,
                    onChanged: _reviewCubit.setRating,
                  ),
                  const SizedBox(height: 32),
                  ReviewCommentField(
                    controller: _comment,
                    enabled: !state.submitting,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 24),
                  ReviewPhotoAttachment(
                    attached: state.photoAttached,
                    enabled: !state.submitting,
                    onTap: _togglePhoto,
                  ),
                  const Spacer(),
                  ReviewSubmitButton(
                    enabled: state.canSubmit(_comment.text),
                    loading: state.submitting,
                    editing: state.editing,
                    onSubmit: _submit,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    await _reviewCubit.submit(_comment.text);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    if (_reviewCubit.state.failed) {
      final wait = _reviewCubit.state.retryAfterMinutes;
      AppFeedback.showSnackBar(
        context,
        // Rounded up to the hour, the way the server rounds its minutes up:
        // rounding down tells someone to come back while still blocked.
        wait > 0
            ? l10n.reviewCooldownNotice((wait + 59) ~/ 60)
            : l10n.reviewSubmitFailed,
      );
      return;
    }
    if (!_reviewCubit.state.submitted) return;
    AppFeedback.showSnackBar(
      context,
      _reviewCubit.state.photoAttached
          ? l10n.reviewSubmittedWithPhoto
          : l10n.reviewSubmitted,
    );
    Navigator.pop(context);
  }

  Future<void> _togglePhoto() async {
    final l10n = AppLocalizations.of(context);
    if (_reviewCubit.hasPhoto) {
      _reviewCubit.removePhoto();
      AppFeedback.showSnackBar(context, l10n.reviewPhotoRemoved);
      return;
    }
    final photo = await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(
        builder: (_) => CameraCaptureScreen(hint: l10n.reviewPhotoHint),
      ),
    );
    if (photo == null || !mounted) return;
    _reviewCubit.attachPhoto(photo);
    AppFeedback.showSnackBar(context, l10n.reviewPhotoAttached);
  }
}
