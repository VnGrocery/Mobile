import 'package:flutter/material.dart';

import 'package:vngrocery/core/widgets/trust_copy.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

Color _gradeColor(TrustGrade grade) {
  switch (grade) {
    case TrustGrade.excellent:
      return AppColors.trustGreen;
    case TrustGrade.good:
      return AppColors.primaryGreen;
    case TrustGrade.watch:
      return AppColors.warningOrange;
    case TrustGrade.risk:
      return AppColors.priceRed;
  }
}

/// Small pill showing just the grade, for shop cards in lists.
class TrustGradeChip extends StatelessWidget {
  final TrustSummary summary;

  const TrustGradeChip({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    // A shop with no signal yet is not "risky"; it simply has nothing to show.
    if (!summary.hasData) return const SizedBox.shrink();

    final color = _gradeColor(summary.grade);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              '${summary.score.round()} · ${TrustCopy.grade(context, summary.grade)}',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full trust breakdown for a shop: headline score, the six sub-scores it is
/// built from, and the server's reasons.
class TrustScoreCard extends StatelessWidget {
  final TrustSummary summary;

  const TrustScoreCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = _gradeColor(summary.grade);
    final reasons = TrustCopy.reasons(context, summary.reasons);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.trustScoreTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (!summary.hasData)
              Text(
                l10n.trustScoreNoData,
                style: const TextStyle(color: AppColors.textSecondary),
              )
            else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${summary.score.round()}',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '/100',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        TrustCopy.grade(context, summary.grade),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.trustScoreBreakdown,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              for (final component in summary.components)
                _ComponentBar(component: component),
              if (reasons.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.trustScoreReasons,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
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
              if (summary.formulaVersion.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.trustScoreFormula(summary.formulaVersion),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ComponentBar extends StatelessWidget {
  final TrustComponent component;

  const _ComponentBar({required this.component});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  TrustCopy.component(context, component.key),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Text(
                '${component.score.round()}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (component.score / 100).clamp(0, 1),
              minHeight: 6,
              backgroundColor: AppColors.lightGray,
            ),
          ),
        ],
      ),
    );
  }
}
