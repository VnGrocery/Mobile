import 'package:flutter/material.dart';

import '../../../data/data_hooks.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';

class SellerMetricGrid extends StatelessWidget {
  final SellerDashboard dashboard;

  const SellerMetricGrid({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        SellerMetricCard(
          label: 'Độ tin cậy',
          value: dashboard.trustGrade,
          color: AppColors.primaryGreen,
        ),
        SellerMetricCard(
          label: 'Sản phẩm',
          value: '${dashboard.products.length}',
          color: Theme.of(context).colorScheme.onSurface,
        ),
        SellerMetricCard(
          label: 'Ghi nhận hôm nay',
          value: '${dashboard.pledgesToday}',
          color: AppColors.primaryGreen,
        ),
        SellerMetricCard(
          label: 'Cảnh báo buyer',
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
