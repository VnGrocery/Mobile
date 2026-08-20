import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerMetricGrid extends StatelessWidget {
  final SellerDashboard dashboard;

  const SellerMetricGrid({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        SellerMetricCard(
          label: l10n.sellerTrustLabel,
          value: dashboard.trustGrade,
          color: AppColors.primaryGreen,
        ),
        SellerMetricCard(
          label: l10n.sellerProductsLabel,
          value: '${dashboard.products.length}',
          color: Theme.of(context).colorScheme.onSurface,
        ),
        SellerMetricCard(
          label: l10n.sellerRecordsToday,
          value: '${dashboard.pledgesToday}',
          color: AppColors.primaryGreen,
        ),
        SellerMetricCard(
          label: l10n.sellerBuyerAlerts,
          value: '${dashboard.warningCount}',
          color: dashboard.warningCount > 0
              ? AppColors.priceRed
              : AppColors.trustGreen,
        ),
      ],
    );
  }
}

class SellerMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const SellerMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
