import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/features/navigation/navigation_item.dart';
import 'floating_tab_item.dart';
import 'scan_diamond_button.dart';

class FloatingTabPopup extends StatelessWidget {
  final List<NavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const FloatingTabPopup({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = context.palette;
    final centerIndex = centerNavigationIndex(items);
    final sideItems = [
      for (var i = 0; i < items.length; i++)
        if (i != centerIndex) i,
    ];
    final leftItems = sideItems.take(2).toList();
    final rightItems = sideItems.skip(2).toList();
    final centerItem = items[centerIndex];

    return SafeArea(
      top: false,
      child: Center(
        child: SizedBox(
          width: 342,
          height: 92,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: palette.glass,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: palette.glassBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.28 : 0.08,
                            ),
                            blurRadius: 28,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 68,
                        child: Row(
                          children: [
                            const SizedBox(width: 18),
                            for (final i in leftItems)
                              Expanded(
                                child: GlassTabItem(
                                  icon: items[i].icon,
                                  label: items[i].label,
                                  selected: i == selectedIndex,
                                  onTap: () => onSelect(i),
                                ),
                              ),
                            const SizedBox(width: 64),
                            for (final i in rightItems)
                              Expanded(
                                child: GlassTabItem(
                                  icon: items[i].icon,
                                  label: items[i].label,
                                  selected: i == selectedIndex,
                                  onTap: () => onSelect(i),
                                ),
                              ),
                            const SizedBox(width: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: ScanDiamondButton(
                  icon: centerItem.icon,
                  selected: centerIndex == selectedIndex,
                  onTap: () => onSelect(centerIndex),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int centerNavigationIndex(List<NavigationItem> items) {
  final scan = items.indexWhere((item) =>
      item.icon == Icons.qr_code_scanner || item.label.contains('Quét'));
  if (scan >= 0) return scan;
  return items.length > 1 ? 1 : 0;
}
