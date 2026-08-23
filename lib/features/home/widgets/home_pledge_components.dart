import 'package:flutter/material.dart';
import 'package:vngrocery/core/widgets/product_thumbnail.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/cart/controllers/cart_bloc.dart';
import 'package:vngrocery/features/cart/controllers/cart_event.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';
import 'package:vngrocery/widgets/score_badge.dart';
import 'package:vngrocery/features/home/home_presenter.dart';

class HomePledgeCard extends StatelessWidget {
  final HomePledgeItem item;

  /// How far the shop is from the reader. Null when the app has no location,
  /// in which case no distance is shown rather than a guessed one.
  final double? distanceKm;

  const HomePledgeCard({super.key, required this.item, this.distanceKm});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final product = item.product;
    final shop = item.shop;
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
            productId: product.id,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // The row is as tall as the score ring plus its label plus the cart
              // button; at 84 the photo sat in the middle of that with air above
              // and below it.
              ProductThumbnail(
                imageUrls: product.imageUrls,
                size: 104,
                radius: 14,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            shop.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        if (distanceKm != null) ...[
                          const Text(
                            ' · ',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            formatDistance(distanceKm!),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatVnd(product.price),
                      style: const TextStyle(
                        color: AppColors.priceRed,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  ScoreRingBadge(score: product.freshnessScore),
                  const SizedBox(height: 8),
                  IconButton.filled(
                    tooltip: l10n.homeAddToCart,
                    onPressed: () {
                      context.read<CartBloc>().add(
                        CartAddRequested(product: product),
                      );
                      AppFeedback.showSnackBar(
                        context,
                        l10n.homeAddedToCart(product.name),
                        icon: Icons.add_shopping_cart_rounded,
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showHomePledgeSheet(BuildContext context, List<HomePledgeItem> items) {
  final palette = context.palette;
  final l10n = AppLocalizations.of(context);
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: palette.elevatedCard,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) => SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.homeRecentChecks,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: l10n.commonClose,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.62,
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => HomePledgeCard(item: items[i]),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
