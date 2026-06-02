import 'package:flutter/material.dart';

import '../features/products/product_presenter.dart';
import '../features/products/widgets/product_detail_components.dart';
import '../theme/app_palette.dart';

class ProductDetailScreen extends StatelessWidget {
  final String shopId;
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.shopId,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final product = ProductPresenter.product(productId);

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: const Text('Thông tin sản phẩm')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const ProductHeroImage(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductTitleBlock(product: product),
                const SizedBox(height: 16),
                ProductScoreCard(score: product.freshnessScore),
                const SizedBox(height: 24),
                const ProductCheckAction(),
                const SizedBox(height: 32),
                ProductCounterInfo(product: product),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
