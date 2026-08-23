import 'package:flutter/material.dart';

import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerProductFilterBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const SellerProductFilterBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: SellerProductPresenter.states.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final state = SellerProductPresenter.states[index];
          final selected = state == value;
          return FilterChip(
            label: Text(
              SellerProductPresenter.stateLabel(
                state,
                AppLocalizations.of(context),
              ),
            ),
            selected: selected,
            showCheckmark: false,
            selectedColor: AppColors.primaryGreen.withValues(alpha: 0.1),
            labelStyle: TextStyle(
              color: selected ? AppColors.primaryGreen : scheme.onSurface,
            ),
            onSelected: (_) => onChanged(state),
          );
        },
      ),
    );
  }
}

class SellerProductEmptyState extends StatelessWidget {
  const SellerProductEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2,
            size: 64,
            color: context.palette.textTertiary,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).sellerProductEmpty,
            style: TextStyle(color: context.palette.textSecondary),
          ),
        ],
      ),
    );
  }
}
