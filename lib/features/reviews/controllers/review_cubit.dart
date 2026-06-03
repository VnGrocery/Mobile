import 'package:flutter_bloc/flutter_bloc.dart';

import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final Duration submitDelay;

  ReviewCubit({
    this.submitDelay = const Duration(milliseconds: 900),
  }) : super(const ReviewState());

  void setRating(int rating) {
    emit(state.copyWith(rating: rating, submitted: false));
  }

  void togglePhoto() {
    emit(
      state.copyWith(
        photoAttached: !state.photoAttached,
        submitted: false,
      ),
    );
  }

  Future<void> submit(String comment) async {
    if (!state.canSubmit(comment)) return;
    emit(state.copyWith(submitting: true, submitted: false));
    await Future<void>.delayed(submitDelay);
    emit(state.copyWith(submitting: false, submitted: true));
  }
}
