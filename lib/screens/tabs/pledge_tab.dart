import 'package:flutter/material.dart';

import '../../data/data_hooks.dart';
import '../../data/session.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_palette.dart';

class PledgeTab extends StatelessWidget {
  final double bottomContentInset;

  const PledgeTab({super.key, this.bottomContentInset = 0});

  @override
  Widget build(BuildContext context) {
    final dashboard = AppDataHooks.instance.getSellerDashboard(
      SessionManager.instance.shopId,
    );
    final canCreatePledge = dashboard.products.isNotEmpty;

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
          Text(
            dashboard.shop.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            'Chế độ seller - dữ liệu demo từ hook',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 18),
          _CreatePledgeCard(canCreatePledge: canCreatePledge),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.sellerProducts,
                    arguments: SessionManager.instance.shopId,
                  ),
                  icon: const Icon(Icons.inventory_2),
                  label: const Text('Sản phẩm'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final firstProduct = dashboard.products.isEmpty
                        ? null
                        : dashboard.products.first;
                    if (firstProduct == null) return;
                    Navigator.pushNamed(
                      context,
                      Routes.pledgeHistory,
                      arguments: firstProduct.id,
                    );
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('Lịch sử'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Chỉ số cửa hàng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.55,
            children: [
              _MetricCard(
                label: 'Độ tin cậy',
                value: dashboard.trustGrade,
                color: AppColors.primaryGreen,
              ),
              _MetricCard(
                label: 'Sản phẩm',
                value: '${dashboard.products.length}',
                color: Theme.of(context).colorScheme.onSurface,
              ),
              _MetricCard(
                label: 'Ghi nhận hôm nay',
                value: '${dashboard.pledgesToday}',
                color: AppColors.primaryGreen,
              ),
              _MetricCard(
                label: 'Cảnh báo buyer',
                value: '${dashboard.warningCount}',
                color: dashboard.warningCount > 0
                    ? AppColors.priceRed
                    : AppColors.trustGreen,
              ),
            ],
          ),
          const SizedBox(height: 22),
          _StatusCard(dashboard: dashboard),
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

class _CreatePledgeCard extends StatelessWidget {
  final bool canCreatePledge;
  const _CreatePledgeCard({required this.canCreatePledge});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryGreen,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: canCreatePledge
            ? () {
                Navigator.pushNamed(
                  context,
                  Routes.sellerProducts,
                  arguments: SessionManager.instance.shopId,
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.add_a_photo, color: Colors.white),
                    const SizedBox(height: 12),
                    const Text(
                      'Thêm ghi nhận sản phẩm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      canCreatePledge
                          ? 'Chọn sản phẩm và lưu thông tin tại quầy.'
                          : 'Cần tạo sản phẩm trước khi ghi nhận.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_forward, color: AppColors.primaryGreen),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
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

class _StatusCard extends StatelessWidget {
  final SellerDashboard dashboard;
  const _StatusCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final latest = dashboard.pledges.isEmpty ? null : dashboard.pledges.first;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tình trạng shop',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _row('Trạng thái', 'active'),
          _row('Tổng ghi nhận', '${dashboard.pledges.length}'),
          _row('Biên lai gần nhất', latest?.proofId ?? 'Chưa có'),
          _row('Integrity',
              dashboard.warningCount > 0 ? 'Cần xem lại' : 'Ổn định'),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
