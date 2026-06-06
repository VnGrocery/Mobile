import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

class SellerPledgeConfirmStep extends StatelessWidget {
  final String score;
  final bool loading;
  final VoidCallback onCommit;

  const SellerPledgeConfirmStep({
    super.key,
    required this.score,
    required this.loading,
    required this.onCommit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.meatRed.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.meatRed.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.sellerPledgeRecordContentTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.meatRed,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(l10n.sellerPledgeRecordPreview(score)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: loading ? null : onCommit,
            child: loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    l10n.sellerPledgeConfirmSave,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }
}
