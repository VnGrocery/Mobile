import 'package:flutter/material.dart';

import 'package:vngrocery/core/widgets/product_thumbnail.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/recommendation_copy.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// The catalogue at the foot of the home page, two cards to a row.
///
/// The order is the server's interest ranking, strongest first - the same
/// signals that drive the suggestions above it: products checked, shops rated,
/// vouchers saved. When the reader has done none of those the server says so,
/// and the heading says "popular" rather than claiming this is personal.
class HomeProductGrid extends StatelessWidget {
  final List<RecommendedProduct> products;

  /// False when the ranking rests on nothing the reader has done, which
  /// changes what the section is allowed to call itself.
  final bool personalised;

  const HomeProductGrid({
    super.key,
    required this.products,
    required this.personalised,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    // Columns filled round-robin rather than a GridView.
    //
    // A grid makes every tile in a row the same height, which means picking a
    // childAspectRatio up front - and no single ratio survives both a one-line
    // and a two-line product name, let alone the system's larger font sizes.
    // The last one clipped the card's own bottom padding and left the distance
    // line welded to the edge. Columns let each card be exactly as tall as
    // what is in it.
    //
    // Two columns on a phone; a fixed two columns on a tablet just draws the
    // same phone card twice as wide with empty space either side, so a third
    // column joins above the same 600dp breakpoint the nav bar already uses.
    final columnCount = MediaQuery.sizeOf(context).width < 600 ? 2 : 3;
    final columns = List.generate(columnCount, (_) => <RecommendedProduct>[]);
    for (var i = 0; i < products.length; i++) {
      columns[i % columnCount].add(products[i]);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < columns.length; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            Expanded(child: _Column(products: columns[i])),
          ],
        ],
      ),
    );
  }
}

class _Column extends StatelessWidget {
  final List<RecommendedProduct> products;

  const _Column({required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < products.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _GridCard(product: products[i]),
        ],
      ],
    );
  }
}

class _GridCard extends StatelessWidget {
  final RecommendedProduct product;

  const _GridCard({required this.product});

  /// Distance when the reader shared one, otherwise the strongest reason the
  /// server gave. Null when there is neither, which hides the line.
  String? _note(AppLocalizations l10n) {
    final distance = product.distanceKm;
    if (distance != null) return formatDistance(distance);
    return RecommendationCopy.headline(
      l10n,
      product.reasons,
      category: product.category,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(
          context,
          Routes.productDetail,
          arguments: ProductDetailArgs(
            shopId: product.shopId,
            productId: product.productId,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ProductThumbnail(
                  imageUrls: product.imageUrls,
                  size: double.infinity,
                  radius: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                product.shopName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: palette.textSecondary),
              ),
              const SizedBox(height: 6),
              Text(
                formatVnd(product.price.round()),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.priceRed,
                ),
              ),
              // Why this card is where it is. A ranked list that never says
              // what it ranked on is indistinguishable from a random one - and
              // a reason nobody could translate is dropped rather than faked.
              if (_note(l10n) case final note?) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      product.distanceKm != null
                          ? Icons.near_me_outlined
                          : Icons.verified_outlined,
                      size: 12,
                      color: palette.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        note,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
