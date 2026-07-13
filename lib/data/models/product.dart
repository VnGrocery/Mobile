import 'json_helpers.dart';

class Product {
  final String id;
  final String shopId;
  String name;
  String description;
  String category;
  int freshnessScore;
  String freshnessNote;
  int price;
  List<String> tags;
  String status;
  int version;
  List<String> imageUrls;

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
  });

  factory Product.fromJson(Map<String, Object?> json) {
    return Product(
      id: (json['productId'] ?? json['id']) as String,
      shopId: json['shopId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      freshnessScore: (json['freshnessScore'] as num).toInt(),
      freshnessNote: json['freshnessNote'] as String,
      price: (json['price'] as num).toInt(),
      tags: stringList(json['tags']),
      status: _productStatus(json['status']?.toString() ?? ''),
      version: (json['version'] as num?)?.toInt() ?? 1,
      imageUrls: stringList(json['imageUrls']),
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
