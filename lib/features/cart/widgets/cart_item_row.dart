import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/utils/currency_formatter.dart';
import 'package:vngrocery/core/widgets/quantity_selector.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/features/cart/controllers/cart_bloc.dart';
import 'package:vngrocery/features/cart/controllers/cart_event.dart';
import 'package:vngrocery/features/cart/models/cart_item.dart';

class CartItemRow extends StatelessWidget {
  final CartItem item;

  const CartItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 58,
            height: 58,
            color: palette.elevatedCard,
            child: Image.asset(
              item.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.image,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                formatCurrencyVnd(item.price),
                style: const TextStyle(
                  color: AppColors.priceRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        QuantitySelector(
          quantity: item.quantity,
          onChanged: (quantity) {
            context.read<CartBloc>().add(
                  CartQuantityChanged(
                    productId: item.productId,
                    quantity: quantity,
                  ),
                );
          },
        ),
      ],
    );
  }
}
