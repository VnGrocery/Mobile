import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class ExploreSearchShell extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback onBack;

  const ExploreSearchShell({
    super.key,
    required this.showBackButton,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Row(
      children: [
        if (showBackButton) ...[
          Material(
            color: palette.elevatedCard,
            elevation: 4,
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Material(
            color: palette.elevatedCard,
            elevation: 4,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.gray),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.exploreSearchNearby,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  Icon(Icons.tune, color: AppColors.primaryGreen),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LocateUserButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LocateUserButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: context.palette.elevatedCard,
      elevation: 4,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: l10n.exploreYourLocation,
        onPressed: onPressed,
        icon: const Icon(Icons.my_location, color: AppColors.primaryGreen),
      ),
    );
  }
}
