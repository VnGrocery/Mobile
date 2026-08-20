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
    // The scan diamond is pinned to the centre of the bar, so the two sides
    // need equal flex or it lands on top of a label. With an odd number of side
    // items the shorter side is padded with an empty slot below.
    final half = sideItems.length ~/ 2;
    final leftItems = sideItems.take(half).toList();
    final rightItems = sideItems.skip(half).toList();
    final leftFillers = rightItems.length - leftItems.length;
    final rightFillers = leftItems.length - rightItems.length;
    final centerItem = items[centerIndex];

    return SafeArea(
      top: false,
      child: Center(
        child: SizedBox(
          width: 342,
          height: 108,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF23AA49).withValues(
                          alpha: isDark ? 0.22 : 0.24,
                        ),
                        blurRadius: 26,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                      if (!isDark)
                        BoxShadow(
                          color:
                              const Color(0xFF23AA49).withValues(alpha: 0.16),
                          blurRadius: 34,
                          spreadRadius: 5,
                          offset: Offset.zero,
                        ),
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.28 : 0.08,
                        ),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.24 : 0.13,
                        ),
                        blurRadius: 22,
                        spreadRadius: -1,
                        offset: const Offset(12, 16),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: isDark
                              ? palette.glass.withValues(alpha: 0.74)
                              : Colors.white.withValues(alpha: 0.76),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isDark
                                ? palette.glassBorder
                                : const Color(0xFF23AA49)
                                    .withValues(alpha: 0.42),
                            width: isDark ? 1 : 1.4,
                          ),
                        ),
                        child: SizedBox(
                          height: 70,
                          child: Row(
                            children: [
                              const SizedBox(width: 18),
                              for (var i = 0; i < leftFillers; i++)
                                const Expanded(child: SizedBox.shrink()),
                              for (final i in leftItems)
                                Expanded(
                                  child: GlassTabItem(
                                    icon: items[i].icon,
                                    label: items[i].label,
                                    selected: i == selectedIndex,
                                    onTap: () => onSelect(i),
                                    selectorKey: items[i].selectorKey,
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
                                    selectorKey: items[i].selectorKey,
                                  ),
                                ),
                              for (var i = 0; i < rightFillers; i++)
                                const Expanded(child: SizedBox.shrink()),
                              const SizedBox(width: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 2,
                child: ScanDiamondButton(
                  icon: centerItem.icon,
                  selected: centerIndex == selectedIndex,
                  onTap: () => onSelect(centerIndex),
                  semanticsLabel: centerItem.label,
                  selectorKey: centerItem.selectorKey,
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
