import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

class HomeSectionTitle extends StatelessWidget {
  final String title;
  final bool showAction;
  final VoidCallback? onSeeAll;

  const HomeSectionTitle(
    this.title, {
    super.key,
    this.showAction = true,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (showAction)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                // shrinkWrap put the actual tap target under the 48dp
                // Material minimum; the default tap target size keeps the
                // text small while restoring a real 48dp hit area.
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                AppLocalizations.of(context).homeSeeAll,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
