import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'review_state.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/data/session.dart';

class ReviewCubit extends Cubit<ReviewState> with CloseSafeEmit {
  final AppRepositories _repositories;
  final String shopId;

  /// Whose review this is. Taken from the session by default; named so a test
  /// does not have to log an account in to exercise an edit.
  final String reviewerUserId;

  ReviewCubit({
    required this.shopId,
    AppRepositories? repositories,
    String? reviewerUserId,
  }) : _repositories = repositories ?? AppRepositories.instance,
       reviewerUserId =
           reviewerUserId ?? SessionManager.instance.current.userId,
       super(const ReviewState());

  /// The reader's existing review of this shop, once [loadExisting] has run.
  Review? _existing;

  /// Fetches what this reader already wrote about this shop, if anything.
  ///
  /// The server keeps one review per account per shop: sending a second one
  /// edits the first, and it refuses the edit unless it names the version it
  /// replaces. Nothing ever fetched that version, so the app sent 0 every
  /// time and every repeat review came back 409.
  ///
  /// Returns the previous comment so the form opens on it rather than blank -
  /// an edit that silently replaces text the reader cannot see is worse than
  /// no edit at all.
  Future<String?> loadExisting() async {
    if (reviewerUserId.isEmpty) return null;
    final List<Review> reviews;
    try {
      reviews = await _repositories.reviews.refresh(shopId);
    } catch (_) {
      // A first review still works without this, and a failed edit reports
      // itself through `failed`, so a dead list must not block the form.
      return null;
    }
    for (final review in reviews) {
      if (review.reviewerUserId != reviewerUserId) continue;
      _existing = review;
      emit(state.copyWith(rating: review.rating, editing: true));
      return review.comment;
    }
    return null;
  }

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
      final imageUrls = <String>[];
      final photo = _photo;
      if (photo != null && _repositories.reviews.remote != null) {
        final url = await _repositories.reviews.remote!.uploadImage(photo);
        if (url != null) imageUrls.add(url);
      }
      await _repositories.reviews.create(
        shopId,
        state.rating,
        comment.trim(),
        imageUrls: imageUrls,
        expectedVersion: _existing?.version ?? 0,
      );
      emit(state.copyWith(submitting: false, submitted: true, failed: false));
    } catch (_) {
      emit(state.copyWith(submitting: false, submitted: false, failed: true));
    }
  }
}
