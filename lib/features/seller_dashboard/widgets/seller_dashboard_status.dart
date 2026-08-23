import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

import 'package:vngrocery/data/repositories.dart';
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
        borderRadius: BorderRadius.circular(16),
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
            // Đây là bằng chứng, không phải một con số thống kê: mã biên nhận
            // mang mặt chữ monospace như mọi hash khác trong app.
            mono: latest?.proofId.trim().isNotEmpty ?? false,
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

  /// Giá trị là một định danh đã ký (mã biên nhận, hash), không phải số liệu.
  final bool mono;

  const SellerStatusRow({
    super.key,
    required this.label,
    required this.value,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: palette.textSecondary),
            ),
          ),
          if (mono)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: palette.mutedSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                  fontFamilyFallback: ['Courier', 'monospace'],
                ),
              ),
            )
          else
            // Trạng thái lạ từ server rơi thẳng ra đây (`_ => status`), nên
            // dòng này phải cắt được thay vì đẩy vỡ hàng.
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }
}
