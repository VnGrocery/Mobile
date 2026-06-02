import 'package:flutter/material.dart';

import '../../../data/models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';
import '../buyer_check_presenter.dart';

class BuyerScoreSummary extends StatelessWidget {
  final BuyerCheckResult result;

  const BuyerScoreSummary({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Điểm đánh giá',
                style: TextStyle(fontSize: 14, color: Colors.grey),
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
                BuyerCheckPresenter.locationLabel(result),
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
          child: Text(
            BuyerCheckPresenter.locationDescription(result),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
