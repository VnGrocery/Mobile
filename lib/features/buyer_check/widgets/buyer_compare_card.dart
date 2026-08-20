import 'package:flutter/material.dart';

import 'package:vngrocery/core/widgets/trust_copy.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Puts the seller's pledge next to what the buyer just measured.
///
/// This is the answer to the question the whole product exists for: did the
/// seller tell the truth?
class BuyerCompareCard extends StatelessWidget {
  final BuyerCheckResult result;

  const BuyerCompareCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final reasons = TrustCopy.reasons(context, result.reasons);

    return Card(
      color: palette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.buyerCheckCompareTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (!result.canCompare)
              Text(
                l10n.buyerCheckNoPledge,
                style: const TextStyle(color: AppColors.textSecondary),
              )
            else ...[
              Row(
                children: [
                  Expanded(
                    child: _ScoreBlock(
                      label: l10n.buyerCheckPledged,
                      value: result.pledgedScore.toStringAsFixed(1),
                    ),
                  ),
                  const Icon(Icons.compare_arrows, color: AppColors.gray),
                  Expanded(
                    child: _ScoreBlock(
                      label: l10n.buyerCheckMeasured,
                      value: result.actualScore.toStringAsFixed(1),
                      color: result.isWorseThanPledged
                          ? AppColors.warningOrange
                          : AppColors.trustGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Row(
                label: l10n.buyerCheckDelta,
                value: result.scoreDelta > 0
                    ? '+${result.scoreDelta.toStringAsFixed(1)}'
                    : result.scoreDelta.toStringAsFixed(1),
                color: result.isWorseThanPledged
                    ? AppColors.warningOrange
                    : AppColors.trustGreen,
              ),
              _Row(
                label: l10n.buyerCheckCategoryMatch,
                value: result.categoryMatch ? '✓' : '✗',
                color: result.categoryMatch
                    ? AppColors.trustGreen
                    : AppColors.warningOrange,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    result.trusted ? Icons.verified : Icons.warning_amber,
                    size: 16,
                    color: result.trusted
                        ? AppColors.trustGreen
                        : AppColors.warningOrange,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      result.trusted
                          ? l10n.buyerCheckTrusted
                          : l10n.buyerCheckNotTrusted,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: result.trusted
                            ? AppColors.trustGreen
                            : AppColors.warningOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (reasons.isNotEmpty) ...[
              const SizedBox(height: 10),
              for (final reason in reasons)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('•  '),
                      Expanded(
                        child: Text(
                          reason,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            if (result.actualConfidence > 0) ...[
              const SizedBox(height: 8),
              Text(
                l10n.buyerCheckConfidence(
                  (result.actualConfidence * 100).round(),
                ),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScoreBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _ScoreBlock({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _Row({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}
