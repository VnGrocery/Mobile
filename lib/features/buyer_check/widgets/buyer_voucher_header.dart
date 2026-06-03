import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

class VoucherCheckHeader extends StatelessWidget {
  final Product product;
  final Shop shop;

  const VoucherCheckHeader({
    super.key,
    required this.product,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.local_offer, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Kiểm tra voucher',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Text(
              formatVnd(product.price),
              style: const TextStyle(
                color: AppColors.priceRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${product.name} - ${shop.name}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: palette.textSecondary),
        ),
      ],
    );
  }
}
