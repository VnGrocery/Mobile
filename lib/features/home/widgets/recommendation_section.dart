import 'package:flutter/material.dart';

import 'package:vngrocery/core/widgets/product_thumbnail.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/recommendation_copy.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// Suggestions for the reader, with the reason each one was suggested.
///
/// The heading changes with the data behind it: "for you" only when the server
/// found something this reader has actually done. Otherwise it says these are
/// widely trusted, because calling a popularity list personal would be a claim
/// nothing supports.
class RecommendationSection extends StatelessWidget {
  final Recommendations recommendations;

  const RecommendationSection({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final products = recommendations.products;
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    recommendations.personalised
                        ? Icons.auto_awesome
                        : Icons.local_fire_department_outlined,
                    size: 18,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    RecommendationCopy.title(l10n, recommendations),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              // Says plainly what the list rests on, so the reader is never
              // left guessing why these are the things being shown.
              Text(
                RecommendationCopy.basis(l10n, recommendations),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          // Tall enough for a card-width photo: the row was cut for a 72dp
          // thumbnail and clipped the price line by 44 when the photo grew.
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) =>
                _SuggestionCard(product: products[index]),
          ),
        ),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final RecommendedProduct product;

  const _SuggestionCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final reason = RecommendationCopy.headline(
      l10n,
      product.reasons,
      category: product.category,
    );

    return SizedBox(
      width: 164,
      child: Material(
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
                // Fills the card. A 72dp square inside a 164dp card left the
                // photo smaller than the name under it, with dead space beside
                // it - and the photo is the fastest thing to recognise at a
                // stall.
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
                  ),
                ),
                Text(
                  product.shopName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (reason != null)
                  // One reason, not all of them: a card has room for the most
                  // useful thing to say, and a wall of chips says nothing.
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: palette.positiveBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      reason,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatVnd(product.price.round()),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.priceRed,
                        ),
                      ),
                    ),
                    if (product.distanceKm != null)
                      Text(
                        formatDistance(product.distanceKm!),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
