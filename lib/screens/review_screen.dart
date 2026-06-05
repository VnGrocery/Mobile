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
    _reviewCubit = ReviewCubit();
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
    if (!mounted || !_reviewCubit.state.submitted) return;
    final l10n = AppLocalizations.of(context);
    AppFeedback.showSnackBar(
      context,
      _reviewCubit.state.photoAttached
          ? l10n.reviewSubmittedWithPhoto
          : l10n.reviewSubmitted,
    );
    Navigator.pop(context);
  }

  void _togglePhoto() {
    _reviewCubit.togglePhoto();
    final l10n = AppLocalizations.of(context);
    AppFeedback.showSnackBar(
      context,
      _reviewCubit.state.photoAttached
          ? l10n.reviewPhotoAttachedDemo
          : l10n.reviewPhotoRemovedDemo,
    );
  }
}
