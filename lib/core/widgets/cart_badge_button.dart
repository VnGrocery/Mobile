import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CartBadgeButton extends StatelessWidget {
  final int itemCount;
  final VoidCallback onTap;

  const CartBadgeButton({
    super.key,
    required this.itemCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Giỏ hàng',
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.shopping_cart_outlined),
          if (itemCount > 0)
            Positioned(
              right: -8,
              top: -8,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.priceRed,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    itemCount > 99 ? '99+' : '$itemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
