import 'json_helpers.dart';

/// Why something was suggested.
///
/// Server keys, translated by the UI. A suggestion nobody can explain is
/// indistinguishable from a random one, so these travel with every item.
class RecommendationReasons {
  const RecommendationReasons._();

  static const categoryYouEngagedWith = 'category_you_engaged_with';
  static const shopYouRated = 'shop_you_rated';
  static const nearYou = 'near_you';
  static const highTrust = 'high_trust';
  static const wellRated = 'well_rated';
}

/// A product suggested to the reader.
class RecommendedProduct {
  final String productId;
  final String shopId;
  final String shopName;
  final String name;
  final String category;
  final double price;
  final List<String> imageUrls;

  /// 0..1. Only used to order the list; never shown, because a bare number
  /// explains nothing.
  final double score;

  final List<String> reasons;

  /// Null when the reader shared no location.
  final double? distanceKm;

  const RecommendedProduct({
    required this.productId,
    required this.shopId,
    required this.shopName,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrls = const [],
    this.score = 0,
    this.reasons = const [],
    this.distanceKm,
  });

  factory RecommendedProduct.fromJson(Map<String, Object?> json) =>
      RecommendedProduct(
        productId: json['productId']?.toString() ?? '',
        shopId: json['shopId']?.toString() ?? '',
        shopName: json['shopName']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        imageUrls: stringList(json['imageUrls']),
        score: (json['score'] as num?)?.toDouble() ?? 0,
        reasons: stringList(json['reasons']),
        distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      );
}

/// A shop suggested to the reader.
class RecommendedShop {
  final String shopId;
  final String name;
  final String address;
  final double trustScore;
  final String trustGrade;
  final double rating;
  final double score;
  final List<String> reasons;
  final double? distanceKm;

  const RecommendedShop({
    required this.shopId,
    required this.name,
    this.address = '',
    this.trustScore = 0,
    this.trustGrade = '',
    this.rating = 0,
    this.score = 0,
    this.reasons = const [],
    this.distanceKm,
  });

  factory RecommendedShop.fromJson(Map<String, Object?> json) =>
      RecommendedShop(
        shopId: json['shopId']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        trustScore: (json['trustScore'] as num?)?.toDouble() ?? 0,
        trustGrade: json['trustGrade']?.toString() ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        score: (json['score'] as num?)?.toDouble() ?? 0,
        reasons: stringList(json['reasons']),
        distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      );
}

/// What the reader is being shown, and what it rests on.
class Recommendations {
  final List<RecommendedProduct> products;
  final List<RecommendedShop> shops;

  /// False when the reader has done nothing the app could learn from. The list
  /// is then ordered by trust and distance, and must be labelled as popular
  /// rather than as personal — calling it "for you" would be a claim the data
  /// does not support.
  final bool personalised;

  /// How many recorded actions the suggestions were derived from, and which
  /// categories those actions fell into.
  final int signalCount;
  final List<String> categories;

  const Recommendations({
    this.products = const [],
    this.shops = const [],
    this.personalised = false,
    this.signalCount = 0,
    this.categories = const [],
  });

  bool get isEmpty => products.isEmpty && shops.isEmpty;

  factory Recommendations.fromJson(Map<String, Object?> json) {
    final products = json['products'];
    final shops = json['shops'];
    return Recommendations(
      products: products is List
          ? products
                .whereType<Map<String, Object?>>()
                .map(RecommendedProduct.fromJson)
                .toList()
          : const [],
      shops: shops is List
          ? shops
                .whereType<Map<String, Object?>>()
                .map(RecommendedShop.fromJson)
                .toList()
          : const [],
      personalised: json['personalised'] as bool? ?? false,
      signalCount: (json['signalCount'] as num?)?.toInt() ?? 0,
      categories: stringList(json['categories']),
    );
  }
}
