import 'package:flutter/material.dart';

import '../../../data/models.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';
import '../../../utils/format.dart';
import '../../../widgets/common.dart';
import '../../../widgets/score_badge.dart';

class ProductHeroImage extends StatelessWidget {
  const ProductHeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          color: palette.card,
          alignment: Alignment.center,
          child: Icon(Icons.image, size: 100, color: palette.textTertiary),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Ảnh từ quầy',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductTitleBlock extends StatelessWidget {
  final Product product;

  const ProductTitleBlock({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          'Giá: ${formatVnd(product.price)} /kg',
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.priceRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ProductScoreCard extends StatelessWidget {
  final int score;

  const ProductScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.meatRed.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.meatRed.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ĐIỂM ĐÁNH GIÁ GẦN NHẤT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.meatRed,
                  ),
                ),
                Text(
                  'Dựa trên ảnh và thông tin đã ghi nhận',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          ScoreRingBadge(
            score: score,
            size: 56,
            scoreFontSize: 20,
            labelFontSize: 8,
          ),
        ],
      ),
    );
  }
}

class ProductCheckAction extends StatelessWidget {
  const ProductCheckAction({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, Routes.aiCompare),
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.onSurface,
              foregroundColor: scheme.surface,
              minimumSize: const Size.fromHeight(56),
            ),
            icon: const Icon(Icons.photo_camera),
            label: const Text(
              'Gửi ảnh kiểm tra sản phẩm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
      ],
    );
  }
}

class ProductCounterInfo extends StatelessWidget {
  final Product product;

  const ProductCounterInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin quầy hàng',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InfoRow(
          icon: Icons.store,
          label: 'Mã cửa hàng',
          value: product.shopId,
        ),
        InfoRow(
          icon: Icons.description,
          label: 'Ghi chú sản phẩm',
          value: product.freshnessNote,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              Routes.storeDetail,
              arguments: product.shopId,
            ),
            child: const Text('Xem thông tin cửa hàng'),
          ),
        ),
      ],
    );
  }
}
