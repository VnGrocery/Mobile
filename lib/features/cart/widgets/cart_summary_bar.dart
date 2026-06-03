import 'package:flutter/material.dart';

import 'package:vngrocery/core/utils/currency_formatter.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/features/cart/controllers/cart_state.dart';

class CartSummaryBar extends StatelessWidget {
  final CartState state;

  const CartSummaryBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: context.palette.card,
        border: Border(top: BorderSide(color: context.palette.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Line(label: 'Tổng tạm tính', value: state.grandSubtotal),
          _Line(label: 'Tổng voucher giảm', value: -state.grandDiscount),
          const SizedBox(height: 6),
          _Line(
            label: 'Tổng tiền nếu tính hết',
            value: state.grandTotal,
            strong: true,
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final String label;
  final int value;
  final bool strong;

  const _Line({
    required this.label,
    required this.value,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: strong ? null : AppColors.textSecondary,
              fontWeight: strong ? FontWeight.w900 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          formatCurrencyVnd(value),
          style: TextStyle(
            color: strong ? AppColors.priceRed : null,
            fontSize: strong ? 18 : 14,
            fontWeight: strong ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
