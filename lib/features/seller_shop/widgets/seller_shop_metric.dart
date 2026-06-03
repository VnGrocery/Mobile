import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_colors.dart';

class SellerShopMetric extends StatelessWidget {
  final String label;
  final String value;

  const SellerShopMetric(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
