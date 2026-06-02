import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../utils/format.dart';

class StoreDetailScreen extends StatefulWidget {
  final String shopId;

  const StoreDetailScreen({super.key, required this.shopId});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  int _tab = 0;

  void _shareShop(Shop shop) {
    Clipboard.setData(
      ClipboardData(
        text:
            '${shop.name}\n${shop.address}\n${shop.rating} điểm đánh giá - ${shop.reviewCount} lượt đánh giá',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã sao chép thông tin cửa hàng')),
    );
  }

  void _openLatestReceipt(List<Product> products) {
    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cửa hàng chưa có biên lai sản phẩm')),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.pledgeHistory,
      arguments: products.first.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = AppDataHooks.instance;
    final shop = data.getShop(widget.shopId);
    final products = data.getProducts(shopId: widget.shopId);
    final reviews = data.getReviews(widget.shopId);

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: const Text('Chi tiết cửa hàng'),
        actions: [
          IconButton(
            onPressed: () => _shareShop(shop),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _header(shop),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sản phẩm mới kiểm tra',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _pledgeCard(products),
              ],
            ),
          ),
          _tabBar(),
          if (_tab == 0)
            ...products.map(
              (product) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: _ProductItem(product: product),
              ),
            )
          else ...[
            ...reviews.map((review) => _ReviewItem(review: review)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.review,
                    arguments: widget.shopId,
                  ),
                  child: const Text('Viết đánh giá'),
                ),
              ),
            ),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _header(Shop shop) {
    final palette = context.palette;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 120,
          color: AppColors.meatRed.withValues(alpha: 0.1),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: palette.elevatedCard,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: palette.mutedSurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.store, size: 40, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                shop.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: palette.positiveBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified,
                      color: AppColors.trustGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${shop.rating} điểm đánh giá',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.trustGreen,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Text(
                  shop.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pledgeCard(List<Product> products) {
    return Card(
      color: context.palette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.verified_user, color: AppColors.meatRed),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sản phẩm đã được kiểm tra gần đây',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    'Có biên lai trong lịch sử',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => _openLatestReceipt(products),
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text(
                'Xem biên lai',
                style: TextStyle(color: AppColors.meatRed),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Row(
      children: List.generate(2, (index) {
        final title = index == 0 ? 'Sản phẩm' : 'Đánh giá';
        final selected = _tab == index;
        return Expanded(
          child: InkWell(
            onTap: () => setState(() => _tab = index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? AppColors.meatRed : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  color: selected ? AppColors.meatRed : Colors.grey,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;

  const _ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: palette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(
          context,
          Routes.productDetail,
          arguments: {'shopId': product.shopId, 'productId': product.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
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
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Cửa hàng: ${product.shopId}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: product.tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    palette.mutedSurface.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatVnd(product.price),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.priceRed,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${product.freshnessScore} điểm',
                          style: TextStyle(
                            color: AppColors.freshnessColor(
                                product.freshnessScore),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final Review review;

  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Card(
      color: palette.card,
      elevation: 0,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 20, backgroundColor: palette.mutedSurface),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: List.generate(
                          review.rating,
                          (_) => const Icon(
                            Icons.star,
                            color: AppColors.warningOrange,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  review.date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.comment, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
