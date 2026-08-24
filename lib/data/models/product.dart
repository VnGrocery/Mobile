import 'json_helpers.dart';

class Product {
  final String id;
  final String shopId;
  String name;
  String description;
  String category;

  /// Freshness on the server's 0-10 scale.
  ///
  /// Was an int, which turned a 9.2 from the server into a 9 — and the score
  /// widgets read it as if it were out of 100, so every real product rendered
  /// red at 9%.
  double freshnessScore;
  String freshnessNote;
  int price;
  List<String> tags;
  String status;
  int version;
  List<String> imageUrls;

  /// When the seller first published it. Null for a product the server has not
  /// dated, which is the local fixture rather than anything real.
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.category,
    required this.freshnessScore,
    required this.freshnessNote,
    required this.price,
    required this.tags,
    required this.status,
    this.version = 1,
    this.imageUrls = const [],
    this.createdAt,
  });

  /// A copy with one or two fields moved.
  ///
  /// The fields are mutable, but a status change is sent to the server as a
  /// whole product: editing the cached instance in place would leave the list
  /// showing the new status even when the request failed.
  Product copyWith({
    String? name,
    String? description,
    String? category,
    double? freshnessScore,
    String? freshnessNote,
    int? price,
    List<String>? tags,
    String? status,
    int? version,
    List<String>? imageUrls,
  }) {
    return Product(
      id: id,
      shopId: shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      freshnessScore: freshnessScore ?? this.freshnessScore,
      freshnessNote: freshnessNote ?? this.freshnessNote,
      price: price ?? this.price,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      version: version ?? this.version,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt,
    );
  }

  factory Product.fromJson(Map<String, Object?> json) {
    return Product(
      id: (json['productId'] ?? json['id']) as String,
      shopId: json['shopId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      freshnessScore: (json['freshnessScore'] as num).toDouble(),
      freshnessNote: json['freshnessNote'] as String,
      price: (json['price'] as num).toInt(),
      tags: stringList(json['tags']),
      status: _productStatus(json['status']?.toString() ?? ''),
      version: (json['version'] as num?)?.toInt() ?? 1,
      imageUrls: stringList(json['imageUrls']),
      createdAt: optionalDateTime(json['createdAt']),
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'shopId': shopId,
    'name': name,
    'description': description,
    'category': category,
    'freshnessScore': freshnessScore,
    'freshnessNote': freshnessNote,
    'price': price,
    'tags': tags,
    'status': status,
    'version': version,
    'imageUrls': imageUrls,
  };
}

String _productStatus(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
}
