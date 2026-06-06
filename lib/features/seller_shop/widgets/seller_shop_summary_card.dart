import 'package:flutter/material.dart';

import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'seller_shop_metric.dart';

class SellerShopSummaryCard extends StatelessWidget {
  final SellerDashboard dashboard;

  const SellerShopSummaryCard({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: palette.elevatedCard,
                child:
                    const Icon(Icons.verified, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dashboard.shop.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      l10n.sellerShopGradeSummary(
                        dashboard.trustGrade,
                        dashboard.shop.rating.toString(),
                      ),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SellerShopMetric(
                l10n.accountMyProducts,
                '${dashboard.products.length}',
              ),
              SellerShopMetric(
                l10n.sellerShopPledgesMetric,
                '${dashboard.pledges.length}',
              ),
              SellerShopMetric(
                l10n.sellerShopWarningsMetric,
                '${dashboard.warningCount}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
