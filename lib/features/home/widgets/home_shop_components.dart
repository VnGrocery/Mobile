import 'package:flutter/material.dart';

import 'package:vngrocery/utils/format.dart';
import 'package:vngrocery/core/widgets/shop_avatar.dart';
import 'package:vngrocery/core/widgets/trust_score_card.dart';
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
                ShopAvatar(shop: shop),
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
                if (shop.trustSummary != null) ...[
                  TrustGradeChip(summary: shop.trustSummary!),
                  const SizedBox(height: 6),
                ],
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.warningOrange,
                      size: 14,
                    ),
                    // Cả hai dòng đều phải cắt được: thẻ cửa hàng rộng cố
                    // định, còn "1.234 đánh giá" thì không - hàng này tràn ra
                    // ngoài thẻ khi số đánh giá dài.
                    Flexible(
                      child: Text(
                        l10n.homeShopRatingValue(formatRating(shop.rating)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        l10n.homeShopReviewCount(shop.reviewCount),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
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
