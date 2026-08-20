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
        return trimmed;
      }
    }
    return null;
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
        child: url == null
            ? _placeholder(size)
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(size),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: size / 3,
                      height: size / 3,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
      ),
    );
  }

  static Widget _placeholder(double size) => Icon(
    Icons.image_outlined,
    color: AppColors.textSecondary,
    size: size / 2.5,
  );
}
