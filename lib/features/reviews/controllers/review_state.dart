class ReviewState {
  final int rating;
  final bool photoAttached;
  final bool submitting;
  final bool submitted;

  const ReviewState({
    this.rating = 0,
    this.photoAttached = false,
    this.submitting = false,
    this.submitted = false,
  });

  bool canSubmit(String comment) {
    return rating > 0 && comment.trim().isNotEmpty && !submitting;
  }

  ReviewState copyWith({
    int? rating,
    bool? photoAttached,
    bool? submitting,
    bool? submitted,
  }) {
    return ReviewState(
      rating: rating ?? this.rating,
      photoAttached: photoAttached ?? this.photoAttached,
      submitting: submitting ?? this.submitting,
      submitted: submitted ?? this.submitted,
    );
  }
}
