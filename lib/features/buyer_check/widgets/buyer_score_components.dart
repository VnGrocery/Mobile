import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/buyer_check/buyer_check_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class BuyerScoreSummary extends StatelessWidget {
  final BuyerCheckResult result;

  const BuyerScoreSummary({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    final color = BuyerCheckPresenter.locationColor(result);

    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.elevatedCard,
            border: Border.all(color: AppColors.warningOrange, width: 8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${result.actualScore}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurface,
                ),
              ),
              Text(
                l10n.scoreBadgeLabel,
                style: TextStyle(fontSize: 14, color: context.palette.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: BuyerCheckPresenter.isNearStore(result)
                ? palette.positiveBg
                : palette.warningBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                BuyerCheckPresenter.locationIcon(result),
                size: 16,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                BuyerCheckPresenter.locationLabel(result, l10n),
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
          child: Text(
            BuyerCheckPresenter.locationDescription(result, l10n),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: context.palette.textSecondary),
          ),
        ),
      ],
    );
  }
}
