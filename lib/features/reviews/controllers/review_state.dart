class ReviewState {
  final int rating;
  final bool photoAttached;
  final bool submitting;
  final bool submitted;

  /// Set when sending failed. Without it the screen just sat there after a
  /// failed submit, giving no sign that anything had gone wrong.
  final bool failed;

  /// Whether this reader has already reviewed the shop, so sending replaces
  /// what they wrote before rather than adding a second review.
  final bool editing;

  /// Minutes left on the server's cooldown when a send was refused for being
  /// too soon. 0 when the failure was anything else.
  ///
  /// A review can only be rewritten every few hours, and "không gửi được"
  /// with no wait attached just makes someone press the button again.
  final int retryAfterMinutes;

  const ReviewState({
    this.rating = 0,
    this.photoAttached = false,
    this.submitting = false,
    this.submitted = false,
    this.failed = false,
    this.editing = false,
    this.retryAfterMinutes = 0,
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
    bool? editing,
    int? retryAfterMinutes,
  }) {
    return ReviewState(
      rating: rating ?? this.rating,
      photoAttached: photoAttached ?? this.photoAttached,
      submitting: submitting ?? this.submitting,
      submitted: submitted ?? this.submitted,
      failed: failed ?? this.failed,
      editing: editing ?? this.editing,
      retryAfterMinutes: retryAfterMinutes ?? this.retryAfterMinutes,
    );
  }
}
