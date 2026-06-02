import 'package:flutter/material.dart';

import '../../data/session.dart';
import '../../features/seller_dashboard/seller_dashboard_presenter.dart';
import '../../features/seller_dashboard/widgets/seller_dashboard_components.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_palette.dart';

class PledgeTab extends StatelessWidget {
  final double bottomContentInset;

  const PledgeTab({super.key, this.bottomContentInset = 0});

  @override
  Widget build(BuildContext context) {
    final dashboard = SellerDashboardPresenter.dashboard(
      SessionManager.instance.shopId,
    );
    final canCreatePledge = SellerDashboardPresenter.canCreatePledge(
      dashboard,
    );

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: const Text(
          'Tổng quan bán hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomContentInset),
        children: [
          SellerDashboardHeader(shopName: dashboard.shop.name),
          const SizedBox(height: 18),
          CreateSellerPledgeCard(
            canCreatePledge: canCreatePledge,
            onTap: () => Navigator.pushNamed(
              context,
              Routes.sellerProducts,
              arguments: SessionManager.instance.shopId,
            ),
          ),
          const SizedBox(height: 14),
          SellerDashboardActions(
            onOpenProducts: () => Navigator.pushNamed(
              context,
              Routes.sellerProducts,
              arguments: SessionManager.instance.shopId,
            ),
            onOpenHistory: () {
              final firstProduct =
                  dashboard.products.isEmpty ? null : dashboard.products.first;
              if (firstProduct == null) return;
              Navigator.pushNamed(
                context,
                Routes.pledgeHistory,
                arguments: firstProduct.id,
              );
            },
          ),
          const SizedBox(height: 22),
          const Text(
            'Chỉ số cửa hàng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SellerMetricGrid(dashboard: dashboard),
          const SizedBox(height: 22),
          SellerStatusCard(dashboard: dashboard),
          const SizedBox(height: 22),
          const Text(
            'Chụp ảnh trong điều kiện đủ sáng để điểm đánh giá ổn định. Mỗi ghi nhận demo sẽ lưu tạm cho đến khi gắn dữ liệu thật.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.35),
          ),
        ],
      ),
    );
  }
}
