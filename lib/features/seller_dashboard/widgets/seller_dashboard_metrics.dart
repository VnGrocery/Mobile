import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerMetricGrid extends StatelessWidget {
  final SellerDashboard dashboard;

  const SellerMetricGrid({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Cố định 2 cột thì trên tablet 4 thẻ vẫn xếp thành ô vuông to giữa màn
    // hình rộng - dùng chung breakpoint 600dp với nav bar để dàn thành 1
    // hàng 4 thẻ thay vì phóng to thẻ phone.
    final crossAxisCount = MediaQuery.sizeOf(context).width < 600 ? 2 : 4;
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      // Ô cao cố định theo tỉ lệ: ở cỡ chữ hệ thống 1.3 lần thì nhãn + số
      // tràn ra ngoài, nên chiều cao ô phải nới theo textScaler.
      childAspectRatio:
          (crossAxisCount == 2 ? 1.55 : 1.15) /
          MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 2.0),
      children: [
        SellerMetricCard(
          label: l10n.sellerTrustLabel,
          value: dashboard.isRated ? dashboard.trustGrade : '—',
          // Figures use trustGreen: the brand green only reaches 2.78:1 on
          // this card, under the 3:1 floor for large text.
          color: context.palette.greenInk,
        ),
        SellerMetricCard(
          label: l10n.sellerProductsLabel,
          value: '${dashboard.products.length}',
          color: Theme.of(context).colorScheme.onSurface,
        ),
        SellerMetricCard(
          label: l10n.sellerRecordsToday,
          value: '${dashboard.pledgesToday}',
          color: context.palette.greenInk,
        ),
        SellerMetricCard(
          label: l10n.sellerBuyerAlerts,
          value: '${dashboard.warningCount}',
          // Đỏ #FF324B chỉ dành cho tiền; cảnh báo là màu cam.
          color: dashboard.warningCount > 0
              ? context.palette.warnInk
              : context.palette.greenInk,
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
        // 14 là bán kính thứ tư, ngoài hệ 8/12/16/20/30.
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: palette.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
