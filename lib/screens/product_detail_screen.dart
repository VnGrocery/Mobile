import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/ui/app_feedback.dart';
import '../features/cart/controllers/cart_bloc.dart';
import '../features/cart/controllers/cart_event.dart';
import '../features/products/controllers/product_detail_cubit.dart';
import '../features/products/controllers/product_detail_state.dart';
import '../features/products/widgets/product_detail_components.dart';
import '../theme/app_palette.dart';

class ProductDetailScreen extends StatefulWidget {
  final String shopId;
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.shopId,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailCubit _productCubit;

  @override
  void initState() {
    super.initState();
    _productCubit = ProductDetailCubit()..load(widget.productId);
  }

  @override
  void dispose() {
    _productCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productCubit,
      child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          final product = state.product;
          if (product == null) {
            return Scaffold(
              backgroundColor: context.palette.appBackground,
              appBar: AppBar(title: const Text('Thông tin sản phẩm')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

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
                            AppFeedback.showSnackBar(
                              context,
                              'Đã thêm ${product.name}',
                              icon: Icons.add_shopping_cart_rounded,
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
        },
      ),
    );
  }
}
