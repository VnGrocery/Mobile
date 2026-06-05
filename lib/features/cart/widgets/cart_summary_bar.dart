import 'package:flutter/material.dart';

import 'package:vngrocery/core/utils/currency_formatter.dart';
import 'package:vngrocery/features/cart/controllers/cart_state.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class CartSummaryBar extends StatelessWidget {
  final CartState state;

  const CartSummaryBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: context.palette.card,
        border: Border(top: BorderSide(color: context.palette.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Line(label: l10n.cartGrandSubtotal, value: state.grandSubtotal),
          _Line(label: l10n.cartGrandDiscount, value: -state.grandDiscount),
          const SizedBox(height: 6),
          _Line(
            label: l10n.cartGrandTotal,
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
