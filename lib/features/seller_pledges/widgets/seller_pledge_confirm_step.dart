import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

class SellerPledgeConfirmStep extends StatelessWidget {
  final String score;
  final bool loading;

  /// Why the seller is recording this score. Hashed and anchored with the
  /// pledge, so the number on a buyer's screen comes with its reasoning.
  final TextEditingController note;
  final ValueChanged<String> onNoteChanged;

  /// Null until the note is long enough to mean anything.
  final VoidCallback? onCommit;

  const SellerPledgeConfirmStep({
    super.key,
    required this.score,
    required this.loading,
    required this.note,
    required this.onNoteChanged,
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
            color: AppColors.primaryGreen.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.sellerPledgeRecordContentTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(l10n.sellerPledgeRecordPreview(score)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: note,
          onChanged: onNoteChanged,
          maxLines: 2,
          maxLength: 200,
          decoration: InputDecoration(
            labelText: l10n.sellerPledgeNoteLabel,
            hintText: l10n.sellerPledgeNoteHint,
            helperText: l10n.changeReasonExplainer,
            helperMaxLines: 2,
          ),
        ),
        const SizedBox(height: 12),
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
