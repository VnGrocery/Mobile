class Review {
  final String id;
  final String userName;
  final int rating;
  final String comment;
  final String date;

  /// Who wrote it. Needed to pick your own review out of a shop's list: there
  /// is no endpoint that returns only yours.
  final String reviewerUserId;

  /// The server keeps one review per shop per account and refuses an edit
  /// that does not name the version it replaces. The app sent 0 every time,
  /// so a second review of the same shop came back 409 forever.
  final int version;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    this.reviewerUserId = '',
    this.version = 0,
  });

  factory Review.fromJson(Map<String, Object?> json) {
    return Review(
      id: (json['reviewId'] ?? json['id']) as String,
      // `reviewerName` is the server's field; it is empty when the account has
      // no display name. Never fall back to reviewerUserId — that printed a raw
      // UUID as the author. The UI supplies a generic label for the empty case.
      userName: (json['reviewerName'] ?? json['userName'] ?? '').toString(),
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      date: (json['date'] ?? json['createdAt'] ?? '').toString(),
      reviewerUserId: json['reviewerUserId']?.toString() ?? '',
      version: (json['version'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'userName': userName,
    'rating': rating,
    'comment': comment,
    'date': date,
    'reviewerUserId': reviewerUserId,
    'version': version,
  };
}
