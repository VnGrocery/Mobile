import 'dart:convert';

/// The contents of a bundle QR code.
///
/// The seller's label carries the `bundleToken` the server issued at commit
/// time: a JWT whose payload already names the bundle, pledge, shop and
/// product. The app reads those claims to build the buyer-check request.
///
/// The signature is deliberately **not** checked here. Only the server holds the
/// key, and it verifies the token on every check, so validating client-side
/// would add nothing but a false sense of safety.
class BundleToken {
  final String raw;
  final String bundleId;
  final String pledgeId;
  final String shopId;
  final String productId;
  final String qrVersion;
  final DateTime? expiresAt;

  const BundleToken({
    required this.raw,
    required this.bundleId,
    required this.pledgeId,
    required this.shopId,
    this.productId = '',
    this.qrVersion = '',
    this.expiresAt,
  });

  /// The QR versions this build knows how to read.
  static const supportedQrVersions = {'bundle_qr_v1'};

  bool get isSupported =>
      qrVersion.isEmpty || supportedQrVersions.contains(qrVersion);

  bool isExpired(DateTime now) {
    final exp = expiresAt;
    return exp != null && now.isAfter(exp);
  }

  /// Enough to identify what was scanned.
  bool get isUsable => bundleId.isNotEmpty && raw.isNotEmpty;

  /// Reads a scanned QR payload. Returns null when it is not one of ours.
  ///
  /// Accepts the bare token, and also a `vngrocery://check?token=...` style URL
  /// so a printed label can double as a link.
  static BundleToken? tryParse(String scanned) {
    final value = scanned.trim();
    if (value.isEmpty) return null;

    final token = _extractToken(value);
    if (token == null) return null;

    final claims = _decodeClaims(token);
    if (claims == null) return null;

    final bundleId = claims['bundleId']?.toString() ?? '';
    if (bundleId.isEmpty) return null;

    final exp = claims['exp'];
    return BundleToken(
      raw: token,
      bundleId: bundleId,
      pledgeId: claims['pledgeId']?.toString() ?? '',
      shopId: claims['shopId']?.toString() ?? '',
      productId: claims['productId']?.toString() ?? '',
      qrVersion: claims['qrVersion']?.toString() ?? '',
      expiresAt: exp is num
          ? DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000, isUtc: true)
          : null,
    );
  }

  static String? _extractToken(String value) {
    if (value.contains('://') || value.startsWith('http')) {
      final uri = Uri.tryParse(value);
      final fromQuery = uri?.queryParameters['token'];
      if (fromQuery != null && fromQuery.isNotEmpty) return fromQuery;
      return null;
    }
    return value;
  }

  static Map<String, Object?>? _decodeClaims(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decoded);
      return json is Map ? Map<String, Object?>.from(json) : null;
    } catch (_) {
      return null;
    }
  }
}
