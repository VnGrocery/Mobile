import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerStatusCard extends StatelessWidget {
  final SellerDashboard dashboard;

  /// Opens the signed record behind these numbers. Null when there is nothing
  /// recorded yet.
  final VoidCallback? onOpenProof;

  const SellerStatusCard({
    super.key,
    required this.dashboard,
    this.onOpenProof,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final latest = dashboard.pledges.isEmpty ? null : dashboard.pledges.first;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // White on the grey page, where the metric tiles are grey: this card
        // carries the evidence and has to outrank them at a glance, not read
        // as one more statistic.
        color: palette.elevatedCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
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
            // DESIGN.md: a shortened identifier is for reading, and tapping it
            // gives you the whole thing.
            copyValue: latest?.proofId,
          ),
          SellerStatusRow(
            label: l10n.sellerIntegrityLabel,
            value: dashboard.warningCount > 0
                ? l10n.sellerNeedsReview
                : l10n.sellerStable,
            // The one line on this screen that claims the record is intact is
            // also the way to go and look at it.
            onTap: onOpenProof,
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

  /// The full identifier behind a shortened [value]; tapping copies it.
  final String? copyValue;

  /// Opens whatever backs this row.
  final VoidCallback? onTap;

  const SellerStatusRow({
    super.key,
    required this.label,
    required this.value,
    this.mono = false,
    this.copyValue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final full = copyValue?.trim() ?? '';

    Widget valueWidget;
    if (mono) {
      valueWidget = Material(
        color: palette.mutedSurface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: full.isEmpty
              ? null
              : () async {
                  await Clipboard.setData(ClipboardData(text: full));
                  if (!context.mounted) return;
                  AppFeedback.showSnackBar(
                    context,
                    l10n.sellerReceiptCopied(value),
                    icon: Icons.copy,
                  );
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
                fontFamilyFallback: ['Courier', 'monospace'],
              ),
            ),
          ),
        ),
      );
    } else {
      // Trạng thái lạ từ server rơi thẳng ra đây (`_ => status`), nên dòng này
      // phải cắt được thay vì đẩy vỡ hàng.
      valueWidget = Flexible(
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      );
    }

    final row = Padding(
      padding: EdgeInsets.symmetric(vertical: mono ? 2 : 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: palette.textSecondary)),
          ),
          valueWidget,
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 18, color: palette.textSecondary),
          ],
        ],
      ),
    );

    if (onTap == null) return row;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: row,
    );
  }
}
