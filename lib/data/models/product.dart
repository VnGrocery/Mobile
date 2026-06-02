part of '../models.dart';

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
  });

  factory Product.fromJson(Map<String, Object?> json) {
    return Product(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      freshnessScore: (json['freshnessScore'] as num).toInt(),
      freshnessNote: json['freshnessNote'] as String,
      price: (json['price'] as num).toInt(),
      tags: stringList(json['tags']),
      status: json['status'] as String,
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
      };
}
