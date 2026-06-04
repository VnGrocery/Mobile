import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final AppDelayService _delayService;
  final Duration submitDelay;

  ReviewCubit({
    this.submitDelay = const Duration(milliseconds: 900),
    AppDelayService delayService = AppDelayService.instance,
  })  : _delayService = delayService,
        super(const ReviewState());

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
    await _delayService.waitDuration(submitDelay);
    emit(state.copyWith(submitting: false, submitted: true));
  }
}
