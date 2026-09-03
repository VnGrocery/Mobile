import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/features/navigation/navigation_item.dart';
import 'floating_tab_item.dart';

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

  static const double _phoneWidth = 342;

  /// A phone-width pill left untouched on a tablet reads as a stray sliver
  /// on a mostly-empty screen. Above the Material medium breakpoint (600dp)
  /// it grows with the screen, capped so it never becomes an absurd
  /// full-bleed bar.
  double _width(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 600) return _phoneWidth;
    return (screenWidth * 0.5).clamp(_phoneWidth, 640.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = context.palette;
    return SafeArea(
      top: false,
      child: Center(
        child: SizedBox(
          width: _width(context),
          height: 84,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF23AA49,
                        ).withValues(alpha: isDark ? 0.22 : 0.24),
                        blurRadius: 26,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                      if (!isDark)
                        BoxShadow(
                          color: const Color(
                            0xFF23AA49,
                          ).withValues(alpha: 0.16),
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
                                : const Color(
                                    0xFF23AA49,
                                  ).withValues(alpha: 0.42),
                            width: isDark ? 1 : 1.4,
                          ),
                        ),
                        child: SizedBox(
                          height: 70,
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              // Every destination gets the same slot: the scan
                              // button used to be pinned to the centre, which
                              // could not be balanced against an odd number of
                              // labels.
                              for (var i = 0; i < items.length; i++)
                                Expanded(
                                  child: GlassTabItem(
                                    icon: items[i].icon,
                                    label: items[i].label,
                                    selected: i == selectedIndex,
                                    onTap: () => onSelect(i),
                                    selectorKey: items[i].selectorKey,
                                    accent:
                                        items[i].icon == Icons.qr_code_scanner,
                                  ),
                                ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
