import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/location/nearby.dart';
import 'dart:typed_data';

import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/models.dart';

class RemoteDataSource {
  const RemoteDataSource(this.client);
  final ApiClient client;

  /// Shops, optionally narrowed to a circle around [near].
  ///
  /// With [near] set the server returns only what is inside [radiusKm],
  /// nearest first, instead of the whole catalogue for the app to sift
  /// through.
  Future<List<Shop>> shops({
    String query = '',
    GeoPoint? near,
    double radiusKm = NearbyRadius.far,
  }) async {
    final located = near != null && near.isSet;
    final json = await client.get(
      '/v1/shops',
      query: {
        'q': query,
        'pageSize': 100,
        // The three go together; sending one alone is rejected.
        if (located) 'lat': near.latitude,
        if (located) 'lng': near.longitude,
        if (located) 'radiusKm': radiusKm,
      },
    );
    return _maps(json['items']).map(Shop.fromJson).toList();
  }

  /// A product's recorded change history and its price series.
  ///
  /// The server decodes the audit log for us: the stored payload is its own Go
  /// domain struct marshalled directly, which is not a shape this app should
  /// have to know.
  Future<ProductHistory> productHistory(String shopId, String productId) async {
    final json = await client.get(
      '/v1/shops/$shopId/products/$productId/history',
    );
    return ProductHistory.fromJson(json);
  }

  /// Shops and products suggested for the signed-in reader.
  ///
  /// [near] narrows and orders by distance the same way the discovery screens
  /// do; without it the server simply leaves proximity out of the ranking.
  Future<Recommendations> recommendations({
    GeoPoint? near,
    double radiusKm = NearbyRadius.far,
    int limit = 10,
  }) async {
    final located = near != null && near.isSet;
    final json = await client.get(
      '/v1/me/recommendations',
      query: {
        'limit': limit,
        if (located) 'lat': near.latitude,
        if (located) 'lng': near.longitude,
        if (located) 'radiusKm': radiusKm,
      },
    );
    return Recommendations.fromJson(json);
  }

  Future<Shop> shop(String id) async =>
      Shop.fromJson(await client.get('/v1/shops/$id'));

  Future<Shop> myShop() async => Shop.fromJson(await client.get('/v1/me/shop'));

  Future<Shop> saveShop({
    String? id,
    required String name,
    required String description,
    required String address,
    required int version,
    double latitude = 0,
    double longitude = 0,
  }) async {
    final body = {
      'expectedVersion': version,
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
    final json = id == null || id.isEmpty
        ? await client.post('/v1/shops', body: body)
        : await client.put('/v1/shops/$id', body: body);
    return Shop.fromJson(json);
  }

  Future<List<Product>> products(String shopId, {bool seller = false}) async {
    final json = await client.get(
      seller
          ? '/v1/seller/shops/$shopId/products'
          : '/v1/shops/$shopId/products',
    );
    return _maps(json['items']).map(Product.fromJson).toList();
  }

  Future<Product> product(String shopId, String productId) async =>
      Product.fromJson(
        await client.get('/v1/shops/$shopId/products/$productId'),
      );

  Future<Product> saveProduct(Product product, {bool create = true}) async {
    final body = {
      'productId': product.id,
      'expectedVersion': product.version,
      'name': product.name,
      'description': product.description,
      'category': product.category,
      'tags': product.tags,
      'imageUrls': product.imageUrls,
      'freshnessNote': product.freshnessNote,
      'freshnessScore': product.freshnessScore,
      'price': product.price,
      'currency': 'VND',
      'status': product.status.toLowerCase(),
    };
    final json = create
        ? await client.post('/v1/shops/${product.shopId}/products', body: body)
        : await client.put(
            '/v1/shops/${product.shopId}/products/${product.id}',
            body: body,
          );
    return Product.fromJson(json);
  }

  Future<List<Review>> reviews(String shopId) async => (await client.getList(
    '/v1/shops/$shopId/reviews',
  )).map((e) => Review.fromJson(_map(e))).toList();

  Future<Review> createReview(
    String shopId,
    int rating,
    String comment, {
    List<String> imageUrls = const [],
  }) async => Review.fromJson(
    await client.post(
      '/v1/shops/$shopId/reviews',
      body: {
        'expectedVersion': 0,
        'rating': rating,
        'comment': comment,
        'imageUrls': imageUrls,
      },
    ),
  );

  Future<String?> uploadImage(Uint8List bytes) async {
    final json = await client.multipart(
      '/v1/media/images',
      bytes: bytes,
      filename: 'review.png',
    );
    final url = json['gatewayUrl']?.toString() ?? '';
    if (url.isNotEmpty) return url;
    final cid = json['imageCid']?.toString() ?? '';
    if (cid.isNotEmpty) return 'ipfs://$cid';
    final hash = json['imageHash']?.toString() ?? '';
    return hash.isEmpty ? null : 'sha256:$hash';
  }

  Future<List<PledgeHistoryItem>> pledges(
    String shopId,
    String productId,
  ) async {
    final json = await client.get(
      '/v1/shops/$shopId/pledges',
      query: {'productId': productId},
    );
    return _maps(json['items']).map(PledgeHistoryItem.fromJson).toList();
  }

  /// The server's blockchain verdict for one pledge.
  ///
  /// Trust information must never block the screen it decorates, so a failed
  /// lookup degrades to a neutral proof instead of throwing.
  Future<PledgeProof> pledgeProof(String shopId, String pledgeId) async {
    try {
      final json = await client.get(
        '/v1/shops/$shopId/pledges/$pledgeId/proof',
      );
      return PledgeProof.fromJson(json);
    } catch (_) {
      return PledgeProof.unknown(pledgeId: pledgeId, shopId: shopId);
    }
  }

  /// Convenience for callers that know a product but not which pledge backs it:
  /// resolves the newest pledge for the product and returns its proof.
  Future<PledgeProof?> latestProductProof(
    String shopId,
    String productId,
  ) async {
    final List<PledgeHistoryItem> items;
    try {
      items = await pledges(shopId, productId);
    } catch (_) {
      return null;
    }
    // The server returns pledges newest-first (ListByShopID sorts by createdAt
    // descending), so the first entry with a pledge id is the current one.
    final withProof = items.where((item) => item.proofId.isNotEmpty).toList();
    if (withProof.isEmpty) return null;
    return pledgeProof(shopId, withProof.first.proofId);
  }

  Future<Map<String, Object?>> score(Uint8List bytes) => client.multipart(
    '/v1/seller/score',
    bytes: bytes,
    filename: 'freshness.png',
  );

  Future<Map<String, Object?>> commit({
    required String shopId,
    required String productId,
    required String bundleId,
    required double score,
    required String category,
    required double confidence,
    required String imageHash,
    required String imageCid,
  }) => client.post(
    '/v1/seller/commit',
    body: {
      'shopId': shopId,
      'productId': productId,
      'bundleId': bundleId,
      'score': score,
      'category': category,
      'confidence': confidence,
      'imageHash': imageHash,
      'imageCid': imageCid,
    },
  );

  Future<Map<String, Object?>> buyerCheck({
    required Uint8List bytes,
    required String pledgeId,
    required String bundleId,
    required String bundleToken,
    String locationStatus = 'unknown',
  }) => client.multipart(
    '/v1/buyer/check',
    bytes: bytes,
    filename: 'buyer-check.png',
    fields: {
      'pledgeId': pledgeId,
      'bundleId': bundleId,
      'bundleToken': bundleToken,
      'locationStatus': locationStatus,
    },
  );

  Future<VoucherCheckResult> checkVoucher(
    String code,
    String shopId,
    int orderValue,
  ) async {
    final json = await client.post(
      '/v1/vouchers/check',
      body: {'code': code, 'shopId': shopId, 'orderValue': orderValue},
    );
    return VoucherCheckResult(
      voucher: json['voucher'] is Map
          ? Voucher.fromJson(_map(json['voucher']))
          : null,
      valid: json['valid'] == true,
      message: json['message']?.toString() ?? '',
      discountAmount: (json['discountAmount'] as num?)?.toInt() ?? 0,
      finalPrice: (json['finalPrice'] as num?)?.toInt() ?? orderValue,
    );
  }

  Future<List<({UserVoucher userVoucher, Voucher voucher})>> wallet() async {
    final json = await client.get('/v1/me/vouchers');
    return _maps(json['items'])
        .map(
          (item) => (
            userVoucher: UserVoucher.fromJson(item),
            voucher: Voucher.fromJson(_map(item['voucher'])),
          ),
        )
        .toList();
  }

  Future<({UserVoucher userVoucher, Voucher voucher})> saveVoucher(
    String voucherId,
  ) async => _walletItem(
    await client.post('/v1/me/vouchers', body: {'voucherId': voucherId}),
  );

  Future<({UserVoucher userVoucher, Voucher voucher})> manualVoucher({
    required String shopId,
    required String code,
    required String title,
    required String note,
    required String codeFormat,
    required DateTime expiresAt,
  }) async => _walletItem(
    await client.post(
      '/v1/me/vouchers/manual',
      body: {
        'shopId': shopId,
        'code': code,
        'title': title,
        'note': note,
        'codeFormat': codeFormat,
        'expiresAt': expiresAt.toUtc().toIso8601String(),
      },
    ),
  );

  Future<({UserVoucher userVoucher, Voucher voucher})> useVoucher(
    String id,
  ) async => _walletItem(await client.post('/v1/me/vouchers/$id/use'));

  ({UserVoucher userVoucher, Voucher voucher}) _walletItem(
    Map<String, Object?> json,
  ) => (
    userVoucher: UserVoucher.fromJson(json),
    voucher: Voucher.fromJson(_map(json['voucher'])),
  );
}

Map<String, Object?> _map(Object? value) =>
    (value as Map).cast<String, Object?>();
List<Map<String, Object?>> _maps(Object? value) =>
    (value as List? ?? const []).map(_map).toList();
