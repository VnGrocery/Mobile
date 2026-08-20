import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Round logo for a shop.
///
/// Every shop card used to draw the same bundled photo of meat, so a vegetable
/// stall and a fruit orchard looked like butchers. This shows the seller's own
/// logo when they uploaded one and a storefront glyph when they did not.
class ShopAvatar extends StatelessWidget {
  final Shop shop;
  final double radius;

  const ShopAvatar({super.key, required this.shop, this.radius = 22});

  /// Uploads come back as a gateway URL; `ipfs://` and `sha256:` forms are
  /// identifiers the image loader cannot fetch.
  String? get _loadableUrl {
    final url = shop.logoUrl?.trim() ?? '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final url = _loadableUrl;

    return CircleAvatar(
      radius: radius,
      backgroundColor: context.palette.elevatedCard,
      child: url == null
          ? _fallback()
          : ClipOval(
              child: Image.network(
                url,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
              ),
            ),
    );
  }

  Widget _fallback() => Icon(
    Icons.storefront,
    color: AppColors.primaryGreen,
    size: radius * 1.1,
  );
}
