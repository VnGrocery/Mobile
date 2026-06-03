import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';
import 'package:vngrocery/widgets/score_badge.dart';

class StoreProductItem extends StatelessWidget {
  final Product product;

  const StoreProductItem({super.key, required this.product});

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
                            color: scoreTrustColor(product.freshnessScore),
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

class StoreProductList extends StatelessWidget {
  final List<Product> products;

  const StoreProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final product in products)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: StoreProductItem(product: product),
          ),
      ],
    );
  }
}
