class ReviewState {
  final int rating;
  final bool photoAttached;
  final bool submitting;
  final bool submitted;

  /// Set when sending failed. Without it the screen just sat there after a
  /// failed submit, giving no sign that anything had gone wrong.
  final bool failed;

  const ReviewState({
    this.rating = 0,
    this.photoAttached = false,
    this.submitting = false,
    this.submitted = false,
    this.failed = false,
  });

  bool canSubmit(String comment) {
    return rating > 0 && comment.trim().isNotEmpty && !submitting;
  }

  ReviewState copyWith({
    int? rating,
    bool? photoAttached,
    bool? submitting,
    bool? submitted,
    bool? failed,
  }) {
    return ReviewState(
      rating: rating ?? this.rating,
      photoAttached: photoAttached ?? this.photoAttached,
      submitting: submitting ?? this.submitting,
      submitted: submitted ?? this.submitted,
      failed: failed ?? this.failed,
    );
  }
}
