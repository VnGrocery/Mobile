import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class GlassTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String selectorKey;

  /// Keeps the brand colour even when the tab is not selected, used to give the
  /// scan action some weight now that it is a normal tab.
  final bool accent;

  const GlassTabItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectorKey,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    // Was a hardcoded light/dark branch duplicating iconMuted's own values.
    final inactiveColor = context.palette.iconMuted;
    // Only the icon carries the accent: a green label too would read as a
    // second selected tab.
    final iconColor = selected || accent
        ? AppColors.primaryGreen
        : inactiveColor;

    return InkWell(
      key: ValueKey('nav.tab.$selectorKey'),
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 22),
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
