import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_palette.dart';
import '../utils/currency_formatter.dart';

class GroceryProductCard extends StatelessWidget {
  final Product product;
  final String? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const GroceryProductCard({
    super.key,
    required this.product,
    this.subtitle,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 72,
                  height: 72,
                  color: palette.elevatedCard,
                  child: Image.asset(
                    'assets/images/lamb_meat.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      formatCurrencyVnd(product.price),
                      style: const TextStyle(
                        color: AppColors.priceRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              if (onAddToCart != null)
                IconButton.filled(
                  tooltip: 'Thêm vào giỏ',
                  onPressed: onAddToCart,
                  icon: const Icon(Icons.add_shopping_cart),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
