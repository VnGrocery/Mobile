class Shop {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final String description;
  final String? logoUrl;

  const Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.description,
    this.logoUrl,
  });

  factory Shop.fromJson(Map<String, Object?> json) {
    return Shop(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      description: json['description'] as String,
      logoUrl: json['logoUrl'] as String?,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'rating': rating,
        'reviewCount': reviewCount,
        'description': description,
        'logoUrl': logoUrl,
      };
}
