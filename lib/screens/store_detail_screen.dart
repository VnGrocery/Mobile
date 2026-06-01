import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';

class StoreDetailScreen extends StatefulWidget {
  final String shopId;
  const StoreDetailScreen({super.key, required this.shopId});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  int _tab = 0;

  void _notImplemented() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang được phát triển')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = AppDataHooks.instance;
    final shop = data.getShop(widget.shopId);
    final products = data.getProducts(shopId: widget.shopId);
    final reviews = data.getReviews(widget.shopId);

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text('Chi tiết cửa hàng'),
        actions: [
          IconButton(onPressed: _notImplemented, icon: const Icon(Icons.share)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _header(shop),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cam kết hiện tại',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _pledgeCard(),
                ],
              ),
            ),
          ),
          _tabBar(),
          if (_tab == 0)
            ...products.map((p) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: _ProductItem(product: p),
                ))
          else ...[
            ...reviews.map((r) => _ReviewItem(review: r)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pushNamed(context, Routes.review,
                      arguments: widget.shopId),
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
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFD3D3D3), shape: BoxShape.circle),
                  child: const Icon(Icons.store, size: 40, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Text(shop.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.trustGreenBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified,
                        color: AppColors.trustGreen, size: 20),
                    const SizedBox(width: 8),
                    Text('${shop.rating} Trust Score',
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: AppColors.trustGreen,
                            fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Text(shop.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pledgeCard() {
    return Card(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.verified_user, color: AppColors.meatRed),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Cam kết chất lượng đạt 8.5+',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Đã xác thực gần đây',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: _notImplemented,
              child: const Text('Xem Proof',
                  style: TextStyle(color: AppColors.meatRed)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Row(
      children: List.generate(2, (i) {
        final title = i == 0 ? 'Sản phẩm' : 'Đánh giá';
        final sel = _tab == i;
        return Expanded(
          child: InkWell(
            onTap: () => setState(() => _tab = i),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: sel ? AppColors.meatRed : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Text(title,
                  style: TextStyle(
                    color: sel ? AppColors.meatRed : Colors.grey,
                    fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                  )),
            ),
          ),
        );
      }),
    );
  }
}

/// ProductItem port từ ui/components/CommonComponents.kt
class _ProductItem extends StatelessWidget {
  final Product product;
  const _ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, Routes.productDetail,
            arguments: {'shopId': product.shopId, 'productId': product.id}),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFD3D3D3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Cửa hàng: ${product.shopId}',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: product.tags
                          .map((t) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD3D3D3)
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(t,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.darkGray)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatVnd(product.price),
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.priceRed,
                                fontSize: 15)),
                        Text('${product.freshnessScore}% Fresh',
                            style: TextStyle(
                                color: AppColors.freshnessColor(
                                    product.freshnessScore),
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
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
    return Card(
      color: AppColors.card,
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
                const CircleAvatar(
                    radius: 20, backgroundColor: Color(0xFFD3D3D3)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Người dùng',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: List.generate(
                        review.rating,
                        (_) => const Icon(Icons.star,
                            color: AppColors.warningOrange, size: 14),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(review.date,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey)),
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
