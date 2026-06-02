import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';

class SellerProductListScreen extends StatefulWidget {
  final String? shopId;
  final double bottomContentInset;

  const SellerProductListScreen({
    super.key,
    required this.shopId,
    this.bottomContentInset = 0,
  });

  @override
  State<SellerProductListScreen> createState() =>
      _SellerProductListScreenState();
}

class _SellerProductListScreenState extends State<SellerProductListScreen> {
  String _state = 'Tất cả';
  static const _states = ['Tất cả', 'Published', 'Draft', 'Archived'];

  void _showProductActions(Product product) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.palette.appBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: context.palette.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              product.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${product.category} - ${_stateLabel(product.status)}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            _actionRow(Icons.visibility, 'Xem chi tiết', () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                Routes.productDetail,
                arguments: {'shopId': product.shopId, 'productId': product.id},
              );
            }),
            _actionRow(Icons.history, 'Xem lịch sử ghi nhận', () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                Routes.pledgeHistory,
                arguments: product.id,
              );
            }),
            _actionRow(Icons.verified_user, 'Thêm ghi nhận mới', () async {
              Navigator.pop(context);
              await Navigator.pushNamed(
                context,
                Routes.sellerCreatePledge,
                arguments: product.id,
              );
              if (mounted) setState(() {});
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final shopId = widget.shopId;
    if (shopId == null || shopId.isEmpty) {
      return Scaffold(
        backgroundColor: context.palette.appBackground,
        appBar: AppBar(
          title: const Text(
            'Sản phẩm của tôi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: Text('Tài khoản của bạn chưa có cửa hàng.'),
        ),
      );
    }

    final all = AppDataHooks.instance.getProducts(shopId: shopId);
    final products = _state == 'Tất cả'
        ? all
        : all.where((p) => p.status == _state).toList();

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: const Text(
          'Sản phẩm của tôi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: widget.bottomContentInset),
        child: FloatingActionButton(
          backgroundColor: AppColors.meatRed,
          foregroundColor: Colors.white,
          onPressed: () async {
            await Navigator.pushNamed(
              context,
              Routes.sellerCreateProduct,
              arguments: shopId,
            );
            if (mounted) setState(() {});
          },
          child: const Icon(Icons.add),
        ),
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
              itemBuilder: (_, index) {
                final state = _states[index];
                final selected = state == _state;
                return FilterChip(
                  label: Text(_stateLabel(state)),
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: AppColors.meatRed.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: selected ? AppColors.meatRed : scheme.onSurface,
                  ),
                  onSelected: (_) => setState(() => _state = state),
                );
              },
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2,
                          size: 64,
                          color: context.palette.textTertiary,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Chưa có sản phẩm nào',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      16 + widget.bottomContentInset,
                    ),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) => _card(products[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final palette = context.palette;
    final bg = switch (status) {
      'Published' => palette.positiveBg,
      'Draft' => palette.mutedSurface,
      _ => palette.warningBg,
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
      child: Text(
        _stateLabel(status),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  String _stateLabel(String status) => switch (status) {
        'Published' => 'Đang bán',
        'Draft' => 'Bản nháp',
        'Archived' => 'Đã ẩn',
        _ => status,
      };

  Widget _card(Product product) {
    final palette = context.palette;
    return Card(
      color: palette.card,
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
                    color: palette.mutedSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Danh mục: ${product.category}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _statusBadge(product.status),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  onPressed: () => _showProductActions(product),
                ),
              ],
            ),
            Divider(height: 24, thickness: 0.5, color: palette.border),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.pledgeHistory,
                      arguments: product.id,
                    ),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        Routes.sellerCreatePledge,
                        arguments: product.id,
                      );
                      if (mounted) setState(() {});
                    },
                    icon: const Icon(Icons.verified_user, size: 16),
                    label: const Text(
                      'Thêm ghi nhận',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionRow(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: context.palette.positiveBg,
        child: Icon(icon, color: AppColors.primaryGreen),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
