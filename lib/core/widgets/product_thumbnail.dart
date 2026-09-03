import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Picture for a product.
///
/// Every product card used to draw the same bundled photo of lamb, so a listing
/// for "Cải ngọt Đà Lạt" showed meat. This renders the seller's own image when
/// there is one and a neutral placeholder when there is not, rather than
/// inventing a picture.
class ProductThumbnail extends StatelessWidget {
  final List<String> imageUrls;

  /// Edge length. [double.infinity] fills whatever box it is given, for a hero
  /// image; the placeholder is sized from the real box in that case rather than
  /// from infinity.
  final double size;
  final double radius;

  const ProductThumbnail({
    super.key,
    required this.imageUrls,
    this.size = 72,
    this.radius = 8,
  });

  /// Uploads come back as a gateway URL. `ipfs://` and `sha256:` forms are
  /// identifiers, not something the image loader can fetch.
  String? get _loadableUrl {
    for (final url in imageUrls) {
      final trimmed = url.trim();
      if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
        return _forEmulator(trimmed);
      }
    }
    return null;
  }

  /// The IPFS gateway URL the server hands back points at its own view of
  /// itself (127.0.0.1:8080, same host the dev API defaults to in
  /// [ApiClient.defaultBaseUrl]). On the emulator that resolves to the
  /// emulator, not the dev machine running the gateway, so every photo
  /// silently failed to load. 10.0.2.2 is the emulator's alias for the host;
  /// a real device or production build already gets a real domain here and
  /// passes through unchanged.
  static String _forEmulator(String url) {
    return url
        .replaceFirst('://127.0.0.1:', '://10.0.2.2:')
        .replaceFirst('://localhost:', '://10.0.2.2:');
  }

  @override
  Widget build(BuildContext context) {
    final url = _loadableUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: size,
        height: size,
        color: context.palette.elevatedCard,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // An infinite size means "fill the parent", so the icon has to be
            // measured against what the parent actually gave us. Dividing
            // infinity produced an infinitely large glyph, which drew nothing.
            final drawn = constraints.biggest.shortestSide.isFinite
                ? constraints.biggest.shortestSide
                : size;

            if (url == null) return _placeholder(drawn);

            // CachedNetworkImage keeps the bytes on disk, so a photo already
            // fetched in a previous session shows immediately on the next cold
            // start instead of being downloaded again.
            // Decode to the size actually drawn. A 60dp thumbnail was
            // decoding a full-resolution Wikimedia photo into memory, once per
            // visible card.
            final pixels =
                (drawn * MediaQuery.devicePixelRatioOf(context)).round();
            return CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              memCacheWidth: pixels,
              memCacheHeight: pixels,
              fadeInDuration: const Duration(milliseconds: 150),
              errorWidget: (_, __, ___) => _placeholder(drawn),
              placeholder: (context, _) => Center(
                child: SizedBox(
                  width: drawn / 3,
                  height: drawn / 3,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _placeholder(double size) => Center(
    child: Icon(
      Icons.image_outlined,
      color: AppColors.textSecondary,
      // Capped so a hero-sized box does not get a glyph the height of the
      // screen.
      size: (size / 2.5).clamp(16, 72),
    ),
  );
}
