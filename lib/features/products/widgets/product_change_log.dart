import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/core/widgets/collapsible_list.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/products/product_history_copy.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// Every recorded change to a product, read as a chain of commits.
///
/// The server writes each mutation into a signed, hash-chained log: an entry
/// carries the SHA-256 of its own content and the id of the one before it, so
/// rewriting any past entry breaks every entry after it. That is what makes
/// this worth showing at all — a price history nobody can quietly edit.
class ProductChangeLog extends StatelessWidget {
  final ProductHistory history;

  const ProductChangeLog({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.link, size: 18, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.productHistoryTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _ChainBadge(verified: history.chainVerified),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.productHistorySubtitle,
            style: TextStyle(
              fontSize: 11,
              color: context.palette.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          // Only the most recent few. A product with a long price record used
          // to print every entry, pushing everything below it off the page.
          CollapsibleList(
            itemCount: history.entries.length,
            itemBuilder: (context, index, isLast) => _ChangeRow(
              entry: history.entries[index],
              // The line is what makes it read as a chain rather than a list;
              // the last entry shown has nothing below it to join to.
              showConnector: !isLast,
            ),
          ),
        ],
      ),
    );
  }
}

/// Says whether the whole record still verifies.
class _ChainBadge extends StatelessWidget {
  final bool verified;

  const _ChainBadge({required this.verified});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: verified ? palette.positiveBg : palette.warningBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verified ? Icons.verified_user : Icons.gpp_maybe,
            size: 13,
            // Ink colours: the badge sits on a tinted background where the
            // brand green measures 2.7:1 and #FF9800 measures 1.97:1.
            color: verified ? palette.greenInk : palette.warnInk,
          ),
          const SizedBox(width: 4),
          Text(
            verified ? l10n.productHistoryVerified : l10n.productHistoryBroken,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: verified
                  ? palette.greenInk
                  : palette.warnInk,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  final ProductHistoryEntry entry;
  final bool showConnector;

  const _ChangeRow({required this.entry, required this.showConnector});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final occurredAt = entry.occurredAt;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChainRail(verified: entry.verified, showConnector: showConnector),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ProductHistoryCopy.action(l10n, entry.action),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _ShaChip(sha: entry.sha, shortSha: entry.shortSha),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (entry.actorName.isNotEmpty) entry.actorName,
                      if (occurredAt != null) formatDateTime(occurredAt),
                    ].join(' · '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: context.palette.textSecondary,
                    ),
                  ),
                  if (entry.reason.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    // The seller's own words for this change, signed with it.
                    // Without this the log said what moved and never why.
                    Text(
                      entry.reason,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        fontStyle: FontStyle.italic,
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                  for (final change in entry.changes) ...[
                    const SizedBox(height: 6),
                    _ChangeLine(change: change),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The dot and the line joining one entry to the next.
class _ChainRail extends StatelessWidget {
  final bool verified;
  final bool showConnector;

  const _ChainRail({required this.verified, required this.showConnector});

  @override
  Widget build(BuildContext context) {
    final colour = verified ? AppColors.primaryGreen : AppColors.warningOrange;

    return Column(
      children: [
        Container(
          width: 11,
          height: 11,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: colour,
            shape: BoxShape.circle,
            border: Border.all(color: colour.withValues(alpha: 0.25), width: 3),
          ),
        ),
        if (showConnector)
          Expanded(
            child: Container(width: 2, color: colour.withValues(alpha: 0.25)),
          ),
      ],
    );
  }
}

/// The short hash, tappable to copy the whole thing.
class _ShaChip extends StatelessWidget {
  final String sha;
  final String shortSha;

  const _ShaChip({required this.sha, required this.shortSha});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Semantics(
      button: true,
      label: l10n.a11yCopyHash,
      child: Material(
        color: palette.mutedSurface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          // Copies the full digest, not the six characters on screen: the short
          // form is for reading, the full one is what you verify against.
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: sha));
            if (!context.mounted) return;
            AppFeedback.showSnackBar(
              context,
              l10n.productHistoryCopied(shortSha),
              icon: Icons.copy,
            );
          },
          child: Padding(
            // 12 vertical, not 3: this is a tap target that copies the full
            // digest, and it measured about 20dp tall against a 48dp floor.
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  shortSha,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    fontFamilyFallback: ['Courier', 'monospace'],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.copy,
                  size: 11,
                  color: context.palette.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One field's before and after, e.g. "Giá 68.000 đ → 72.000 đ".
class _ChangeLine extends StatelessWidget {
  final FieldChange change;

  const _ChangeLine({required this.change});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${ProductHistoryCopy.field(l10n, change.field)}: ',
          style: TextStyle(fontSize: 12, color: context.palette.textSecondary),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: ProductHistoryCopy.value(change.field, change.before),
                  style: TextStyle(
                    fontSize: 12,
                    color: context.palette.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const TextSpan(text: '  →  ', style: TextStyle(fontSize: 12)),
                TextSpan(
                  text: ProductHistoryCopy.value(change.field, change.after),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
