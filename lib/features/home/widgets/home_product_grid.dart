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

    return GridView.builder(
      // Inside the page's own scroll view: the grid is the tail of the home
      // list, not a second scrolling surface competing with it.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // Square photo plus two lines of name, the shop, and the price row.
        childAspectRatio: 0.62,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => _GridCard(product: products[index]),
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
              const Spacer(),
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
