import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'review_state.dart';
import 'package:vngrocery/data/repositories.dart';

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

  /// Bytes of the photo the reviewer took, if any. Reviews used to attach a
  /// bundled picture of meat regardless of what was being reviewed.
  Uint8List? _photo;

  bool get hasPhoto => _photo != null;

  void attachPhoto(Uint8List photo) {
    _photo = photo;
    emit(state.copyWith(photoAttached: true, submitted: false));
  }

  void removePhoto() {
    _photo = null;
    emit(state.copyWith(photoAttached: false, submitted: false));
  }

  Future<void> submit(String comment) async {
    if (!state.canSubmit(comment)) return;
    emit(state.copyWith(submitting: true, submitted: false, failed: false));
    try {
      final id = shopId;
      if (id == null) {
        await _delayService.wait(AppDelayKind.reviewSubmit);
      } else {
        final imageUrls = <String>[];
        final photo = _photo;
        if (photo != null && _repositories.reviews.remote != null) {
          final url = await _repositories.reviews.remote!.uploadImage(photo);
          if (url != null) imageUrls.add(url);
        }
        await _repositories.reviews.create(
          id,
          state.rating,
          comment.trim(),
          imageUrls: imageUrls,
        );
      }
      emit(state.copyWith(submitting: false, submitted: true, failed: false));
    } catch (_) {
      emit(state.copyWith(submitting: false, submitted: false, failed: true));
    }
  }
}
