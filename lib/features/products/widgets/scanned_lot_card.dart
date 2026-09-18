import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/pledge_history/pledge_history_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';
import 'package:vngrocery/widgets/score_badge.dart';

/// What the seller pledged for the lot whose label was just scanned.
///
/// Sits at the very top of the product page, above the product's own numbers,
/// because the two disagree and the scanned one answers the question the buyer
/// asked. A crate label names one lot; the page below shows the newest lot,
/// which is a different crate with a different score.
class ScannedLotCard extends StatelessWidget {
  final String lotCode;
  final PledgeHistoryItem lot;

  /// Opens the freshness self-report. Placed here as well as further down the
  /// page because this card is what a buyer reacts to when they disagree with
  /// the number, and the copy further down sits a full screen away.
  final VoidCallback? onRate;

  const ScannedLotCard({
    super.key,
    required this.lotCode,
    required this.lot,
    this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final committed = formatShortDate(lot.time);
    final description = PledgeHistoryPresenter.description(l10n, lot);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.scannedLotTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Selectable so someone checking a scuffed label against
                    // the screen can copy the code rather than retype it.
                    SelectableText(
                      lotCode,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (committed.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.scannedLotCommitted(committed),
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (lot.score != null)
                ScoreRingBadge(
                  score: lot.score!,
                  size: 56,
                  scoreFontSize: 20,
                  labelFontSize: 11,
                ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
          ],
          if (onRate != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: const ValueKey('scanned_lot.rate_freshness'),
                onPressed: onRate,
                icon: const Icon(Icons.rate_review_outlined),
                label: Text(l10n.freshnessReportAction),
              ),
            ),
        ],
      ),
    );
  }
}
