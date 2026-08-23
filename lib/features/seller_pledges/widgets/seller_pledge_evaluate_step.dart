import 'package:flutter/material.dart';

import 'package:vngrocery/features/home/category_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

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
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: palette.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  l10n.sellerPledgeSuggestedScoreTitle,
                  style: const TextStyle(
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
                    color: AppColors.primaryGreen,
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
        Text(
          l10n.sellerPledgeSellerScoreTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: sellerScore,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.sellerPledgeSellerScoreLabel,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: onContinue,
            child: Text(
              l10n.sellerPledgeContinueConfirm,
              style: const TextStyle(fontWeight: FontWeight.bold),
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
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (_) => CategoryPresenter.selectable
          .map(
            (category) => PopupMenuItem(
              value: category,
              child: Text(CategoryPresenter.label(l10n, category)),
            ),
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
              l10n.sellerPledgeCategoryValue(
                CategoryPresenter.label(l10n, category),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
