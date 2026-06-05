import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class VoucherSummaryCard extends StatelessWidget {
  final int usableCount;
  final int total;

  const VoucherSummaryCard({
    super.key,
    required this.usableCount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.positiveBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(Icons.wallet, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.voucherWalletUsableCount(usableCount),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Text(
                  l10n.voucherWalletTotalCount(total),
                  style: TextStyle(color: palette.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VoucherEmptyState extends StatelessWidget {
  const VoucherEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.local_offer_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            l10n.voucherWalletEmptyTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.voucherWalletEmptyBody,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class VoucherWalletToolbar extends StatelessWidget {
  final bool showUsed;
  final ValueChanged<bool> onShowUsedChanged;

  const VoucherWalletToolbar({
    super.key,
    required this.showUsed,
    required this.onShowUsedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.voucherWalletSectionTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FilterChip(
          selected: showUsed,
          showCheckmark: false,
          label: Text(l10n.voucherWalletShowUsed),
          onSelected: onShowUsedChanged,
        ),
      ],
    );
  }
}
