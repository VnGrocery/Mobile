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
          // Was the literal string 'active', so a suspended shop was told it
          // was open for business.
          SellerStatusRow(
            label: l10n.sellerStatusLabel,
            value: _shopState(l10n, dashboard.shop.status),
          ),
          SellerStatusRow(
            label: l10n.sellerTotalRecords,
            value: '${dashboard.pledges.length}',
          ),
          SellerStatusRow(
            label: l10n.sellerLatestReceipt,
            // A full UUID told the shopkeeper nothing and filled the row.
            // Shortened the way receipts are shown elsewhere in the app.
            value: _shortReceipt(latest?.proofId) ?? l10n.sellerNone,
          ),
          SellerStatusRow(
            label: l10n.sellerIntegrityLabel,
            value: dashboard.warningCount > 0
                ? l10n.sellerNeedsReview
                : l10n.sellerStable,
          ),
        ],
      ),
    );
  }
}

/// The shop's own state, in words rather than as the server's key.
String _shopState(AppLocalizations l10n, String status) {
  return switch (status.toLowerCase()) {
    'active' => l10n.sellerShopStateActive,
    'suspended' => l10n.sellerShopStateSuspended,
    'deleted' => l10n.sellerShopStateDeleted,
    _ => status,
  };
}

/// First block of a receipt id, which is all anyone reads off a screen.
String? _shortReceipt(String? proofId) {
  final id = proofId?.trim() ?? '';
  if (id.isEmpty) return null;
  return id.length <= 8 ? id : id.substring(0, 8);
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
