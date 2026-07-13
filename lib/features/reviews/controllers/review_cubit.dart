import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'review_state.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:flutter/services.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final AppDelayService _delayService;
  final AppRepositories _repositories;
  final String? shopId;

  ReviewCubit({
    this.shopId,
    AppRepositories? repositories,
    AppDelayService delayService = AppDelayService.instance,
  }) : _delayService = delayService,
       _repositories = repositories ?? AppRepositories.instance,
       super(const ReviewState());

  void setRating(int rating) {
    emit(state.copyWith(rating: rating, submitted: false));
  }

  void togglePhoto() {
    emit(state.copyWith(photoAttached: !state.photoAttached, submitted: false));
  }

  Future<void> submit(String comment) async {
    if (!state.canSubmit(comment)) return;
    emit(state.copyWith(submitting: true, submitted: false));
    try {
      final id = shopId;
      if (id == null) {
        await _delayService.wait(AppDelayKind.reviewSubmit);
      } else {
        final imageUrls = <String>[];
        if (state.photoAttached && _repositories.reviews.remote != null) {
          final data = await rootBundle.load('assets/images/meat.png');
          final url = await _repositories.reviews.remote!.uploadImage(
            data.buffer.asUint8List(),
          );
          if (url != null) imageUrls.add(url);
        }
        await _repositories.reviews.create(
          id,
          state.rating,
          comment.trim(),
          imageUrls: imageUrls,
        );
      }
      emit(state.copyWith(submitting: false, submitted: true));
    } catch (_) {
      emit(state.copyWith(submitting: false, submitted: false));
    }
  }
}
