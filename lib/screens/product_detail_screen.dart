import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../utils/format.dart';
import '../widgets/common.dart';

class ProductDetailScreen extends StatelessWidget {
  final String shopId;
  final String productId;
  const ProductDetailScreen(
      {super.key, required this.shopId, required this.productId});

  @override
  Widget build(BuildContext context) {
    final product = AppDataHooks.instance.getProduct(productId);
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: const Text('Thông tin sản phẩm')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Ảnh sản phẩm
          Stack(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                color: palette.card,
                alignment: Alignment.center,
                child:
                    Icon(Icons.image, size: 100, color: palette.textTertiary),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Ảnh từ quầy',
                      style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Giá: ${formatVnd(product.price)} /kg',
                    style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.priceRed,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                // Điểm đánh giá
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.meatRed.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.meatRed.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('ĐIỂM ĐÁNH GIÁ GẦN NHẤT',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.meatRed)),
                            Text('Dựa trên ảnh và thông tin đã ghi nhận',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text('${product.freshnessScore}',
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: AppColors.meatRed)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.aiCompare),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.onSurface,
                      foregroundColor: scheme.surface,
                      minimumSize: const Size.fromHeight(56),
                    ),
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Gửi ảnh kiểm tra sản phẩm',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4, right: 4),
                  child: Text(
                    'Hãy chụp ảnh bảng giá hoặc sản phẩm để so với dữ liệu gần nhất.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Thông tin quầy hàng',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                InfoRow(
                    icon: Icons.store,
                    label: 'Mã cửa hàng',
                    value: product.shopId),
                InfoRow(
                    icon: Icons.description,
                    label: 'Ghi chú sản phẩm',
                    value: product.freshnessNote),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(
                        context, Routes.storeDetail,
                        arguments: product.shopId),
                    child: const Text('Xem thông tin cửa hàng'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
