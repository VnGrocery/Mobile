import 'json_helpers.dart';
import 'trust_summary.dart';

class Shop {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final String description;
  final String? logoUrl;
  final double latitude;
  final double longitude;
  final String status;
  final int version;

  /// The shop screens product comments before buyers read them. Shown to
  /// buyers and discounted in the trust score, so it is part of the shop's
  /// public shape rather than a private setting.
  final bool commentModeration;

  /// Server-computed trust verdict. Null when the payload predates it or the
  /// shop came from local mock data.
  final TrustSummary? trustSummary;

  /// When the shop was created, used to order by "newest". Null when the
  /// payload omits it, in which case the shop sorts last.
  final DateTime? createdAt;

  const Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.description,
    this.logoUrl,
    this.latitude = 0,
    this.longitude = 0,
    this.status = 'active',
    this.version = 1,
    this.commentModeration = false,
    this.trustSummary,
    this.createdAt,
  });

  factory Shop.fromJson(Map<String, Object?> json) {
    return Shop(
      id: (json['shopId'] ?? json['id']) as String,
      name: json['name'] as String,
      address: json['address'] as String,
      rating:
          ((json['ratingSummary'] is Map
                      ? (json['ratingSummary'] as Map)['averageRating']
                      : json['rating'])
                  as num?)
              ?.toDouble() ??
          0,
      reviewCount:
          ((json['ratingSummary'] is Map
                      ? (json['ratingSummary'] as Map)['ratingCount']
                      : json['reviewCount'])
                  as num?)
              ?.toInt() ??
          0,
      description: json['description'] as String,
      logoUrl: json['logoUrl'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? 'active',
      version: (json['version'] as num?)?.toInt() ?? 1,
      commentModeration: json['commentModeration'] == true,
      createdAt: optionalDateTime(json['createdAt']),
      trustSummary: json['trustSummary'] is Map
          ? TrustSummary.fromJson(
              Map<String, Object?>.from(json['trustSummary'] as Map),
            )
          : null,
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
    'latitude': latitude,
    'longitude': longitude,
    'status': status,
    'version': version,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (trustSummary != null) 'trustSummary': trustSummary!.toJson(),
  };
}
