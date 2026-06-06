import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class HomeTrustShopCard extends StatelessWidget {
  final Shop shop;

  const HomeTrustShopCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return SizedBox(
      width: 170,
      child: Material(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(
            context,
            Routes.storeDetail,
            arguments: StoreDetailArgs(shop.id),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: palette.elevatedCard,
                  child: Image.asset(
                    'assets/images/meat.png',
                    width: 26,
                    height: 26,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.storefront,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  shop.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.warningOrange,
                      size: 14,
                    ),
                    Text(
                      l10n.homeShopRatingValue(shop.rating.toString()),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.homeShopReviewCount(shop.reviewCount),
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
