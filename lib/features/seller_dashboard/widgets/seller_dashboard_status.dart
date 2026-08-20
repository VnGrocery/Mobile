import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerStatusCard extends StatelessWidget {
  final SellerDashboard dashboard;

  const SellerStatusCard({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final latest = dashboard.pledges.isEmpty ? null : dashboard.pledges.first;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.sellerShopStatusTitle,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SellerStatusRow(label: l10n.sellerStatusLabel, value: 'active'),
          SellerStatusRow(
            label: l10n.sellerTotalRecords,
            value: '${dashboard.pledges.length}',
          ),
          SellerStatusRow(
            label: l10n.sellerLatestReceipt,
            value: latest?.proofId ?? l10n.sellerNone,
          ),
          SellerStatusRow(
            label: 'Integrity',
            value: dashboard.warningCount > 0
                ? l10n.sellerNeedsReview
                : l10n.sellerStable,
          ),
        ],
      ),
    );
  }
}

class SellerStatusRow extends StatelessWidget {
  final String label;
  final String value;

  const SellerStatusRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
