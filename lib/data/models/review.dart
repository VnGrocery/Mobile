class Review {
  final String id;
  final String userName;
  final int rating;
  final String comment;
  final String date;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromJson(Map<String, Object?> json) {
    return Review(
      id: (json['reviewId'] ?? json['id']) as String,
      // Falling back to reviewerUserId printed a raw UUID as the author name.
      // The server sends no display name for reviewers, so this stays empty and
      // the UI supplies a generic label in the reader's language.
      userName: (json['userName'] ?? '').toString(),
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      date: (json['date'] ?? json['createdAt'] ?? '').toString(),
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'userName': userName,
    'rating': rating,
    'comment': comment,
    'date': date,
  };
}
