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
      userName: (json['userName'] ?? json['reviewerUserId'] ?? 'Người dùng')
          .toString(),
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
