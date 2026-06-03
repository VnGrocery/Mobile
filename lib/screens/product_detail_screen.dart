import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/cart/controllers/cart_bloc.dart';
import '../features/cart/controllers/cart_event.dart';
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
                const SizedBox(height: 12),
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      context
                          .read<CartBloc>()
                          .add(CartAddRequested(product: product));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã thêm ${product.name}')),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Thêm vào giỏ'),
                  ),
                ),
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
