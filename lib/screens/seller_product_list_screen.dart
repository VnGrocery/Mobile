import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

class SellerProductListScreen extends StatefulWidget {
  final String? shopId;
  const SellerProductListScreen({super.key, required this.shopId});

  @override
  State<SellerProductListScreen> createState() =>
      _SellerProductListScreenState();
}

class _SellerProductListScreenState extends State<SellerProductListScreen> {
  String _state = 'Tất cả';
  static const _states = ['Tất cả', 'Published', 'Draft', 'Archived'];

  @override
  Widget build(BuildContext context) {
    final shopId = widget.shopId;
    if (shopId == null || shopId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
            title: const Text('Sản phẩm của tôi',
                style: TextStyle(fontWeight: FontWeight.bold))),
        body: const Center(child: Text('Tài khoản của bạn chưa có cửa hàng.')),
      );
    }

    final all = AppDataHooks.instance.getProducts(shopId: shopId);
    final products = _state == 'Tất cả'
        ? all
        : all.where((p) => p.status == _state).toList();

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text('Sản phẩm của tôi',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.meatRed,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.pushNamed(context, Routes.sellerCreateProduct,
              arguments: shopId);
          if (mounted) setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _states.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final s = _states[i];
                final sel = s == _state;
                return FilterChip(
                  label: Text(_stateLabel(s)),
                  selected: sel,
                  showCheckmark: false,
                  selectedColor: AppColors.meatRed.withValues(alpha: 0.1),
                  labelStyle:
                      TextStyle(color: sel ? AppColors.meatRed : Colors.black),
                  onSelected: (_) => setState(() => _state = s),
                );
              },
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.inventory_2,
                            size: 64, color: Color(0xFFD3D3D3)),
                        SizedBox(height: 8),
                        Text('Chưa có sản phẩm nào',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _card(products[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final bg = switch (status) {
      'Published' => AppColors.trustGreenBg,
      'Draft' => AppColors.lightGray,
      _ => AppColors.warningBg,
    };
    final fg = switch (status) {
      'Published' => AppColors.trustGreen,
      'Draft' => Colors.grey,
      _ => AppColors.warningOrange,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(_stateLabel(status),
          style:
              TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  String _stateLabel(String status) => switch (status) {
        'Published' => 'Đang bán',
        'Draft' => 'Bản nháp',
        'Archived' => 'Đã ẩn',
        _ => status,
      };

  Widget _card(Product p) {
    return Card(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('Danh mục: ${p.category}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      _statusBadge(p.status),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Tính năng đang được phát triển')),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5, color: Color(0xFFD3D3D3)),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Navigator.pushNamed(
                        context, Routes.pledgeHistory,
                        arguments: p.id),
                    icon: const Icon(Icons.history, size: 16),
                    label:
                        const Text('Lịch sử', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      await Navigator.pushNamed(
                          context, Routes.sellerCreatePledge,
                          arguments: p.id);
                      if (mounted) setState(() {});
                    },
                    icon: const Icon(Icons.verified_user, size: 16),
                    label: const Text('Thêm ghi nhận',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
