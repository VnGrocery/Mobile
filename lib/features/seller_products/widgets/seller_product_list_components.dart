import 'package:flutter/material.dart';

import '../../../data/models.dart';
import '../../../theme/app_palette.dart';
import '../seller_product_presenter.dart';

class SellerProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onMore;
  final VoidCallback onOpenHistory;
  final VoidCallback onCreatePledge;

  const SellerProductCard({
    super.key,
    required this.product,
    required this.onMore,
    required this.onOpenHistory,
    required this.onCreatePledge,
  });

  @override
  Widget build(BuildContext context) {
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
                      SellerProductStatusBadge(status: product.status),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  onPressed: onMore,
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
                    onPressed: onOpenHistory,
                    icon: const Icon(Icons.history, size: 16),
                    label: const Text(
                      'Lịch sử',
                      style: TextStyle(fontSize: 12),
                    ),
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
                    onPressed: onCreatePledge,
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
}

class SellerProductList extends StatelessWidget {
  final List<Product> products;
  final double bottomContentInset;
  final ValueChanged<Product> onMore;
  final ValueChanged<Product> onOpenHistory;
  final ValueChanged<Product> onCreatePledge;

  const SellerProductList({
    super.key,
    required this.products,
    required this.bottomContentInset,
    required this.onMore,
    required this.onOpenHistory,
    required this.onCreatePledge,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomContentInset),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final product = products[index];
        return SellerProductCard(
          product: product,
          onMore: () => onMore(product),
          onOpenHistory: () => onOpenHistory(product),
          onCreatePledge: () => onCreatePledge(product),
        );
      },
    );
  }
}

class SellerProductStatusBadge extends StatelessWidget {
  final String status;

  const SellerProductStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bg = SellerProductPresenter.statusBackground(context, status);
    final fg = SellerProductPresenter.statusForeground(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(
        SellerProductPresenter.stateLabel(status),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}
