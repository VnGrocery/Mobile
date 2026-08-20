import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

import 'package:vngrocery/theme/app_colors.dart';

class GlassTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String selectorKey;

  const GlassTabItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectorKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark
        ? const Color(0xFF9CAEA0)
        : const Color(0xFF8BA1B2);

    return InkWell(
      key: ValueKey('nav.tab.$selectorKey'),
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primaryGreen : inactiveColor,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              shortNavigationLabel(AppLocalizations.of(context), label),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? AppColors.primaryGreen : inactiveColor,
                fontSize: 10.5,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The scan tab has a long label in the side menu but only a sliver of room in
/// the bottom bar, so it is shortened there.
String shortNavigationLabel(AppLocalizations l10n, String value) {
  if (value == l10n.navScanProducts) return l10n.navScanShort;
  return value;
}
