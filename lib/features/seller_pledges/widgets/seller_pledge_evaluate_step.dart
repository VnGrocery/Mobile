import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/features/seller_pledges/seller_pledge_presenter.dart';

class SellerPledgeEvaluateStep extends StatelessWidget {
  final double aiScore;
  final TextEditingController sellerScore;
  final String category;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onContinue;

  const SellerPledgeEvaluateStep({
    super.key,
    required this.aiScore,
    required this.sellerScore,
    required this.category,
    required this.onCategoryChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: palette.card,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'ĐIỂM GỢI Ý TỪ ẢNH',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '$aiScore',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: AppColors.freshGreen,
                  ),
                ),
                SellerPledgeCategoryPill(
                  category: category,
                  onChanged: onCategoryChanged,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'ĐIỂM NGƯỜI BÁN NHẬP',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: sellerScore,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Nhập điểm đánh giá (0-10)',
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: onContinue,
            child: const Text(
              'Tiếp tục xác nhận',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class SellerPledgeCategoryPill extends StatelessWidget {
  final String category;
  final ValueChanged<String> onChanged;

  const SellerPledgeCategoryPill({
    super.key,
    required this.category,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (_) => SellerPledgePresenter.categories
          .map(
            (category) => PopupMenuItem(value: category, child: Text(category)),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: palette.mutedSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Loại: $category',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
