import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';
import '../seller_product_presenter.dart';

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
            label: Text(SellerProductPresenter.stateLabel(state)),
            selected: selected,
            showCheckmark: false,
            selectedColor: AppColors.meatRed.withValues(alpha: 0.1),
            labelStyle: TextStyle(
              color: selected ? AppColors.meatRed : scheme.onSurface,
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
          const Text(
            'Chưa có sản phẩm nào',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
