import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_colors.dart';

class SideMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool open;
  final int delayIndex;
  final bool selected;
  final VoidCallback onTap;
  final String? selectorKey;

  const SideMenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.open,
    required this.delayIndex,
    required this.selected,
    required this.onTap,
    this.selectorKey,
  });

  @override
  Widget build(BuildContext context) {
    final delay = Duration(milliseconds: 40 * delayIndex);
    return AnimatedSlide(
      duration: Duration(milliseconds: 260 + 24 * delayIndex),
      curve: Curves.easeOutCubic,
      offset: open ? Offset.zero : const Offset(-0.16, 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220) + delay,
        curve: Curves.easeOutCubic,
        opacity: open ? 1 : 0,
        child: Material(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            key: selectorKey == null
                ? null
                : ValueKey('account.route.$selectorKey'),
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: selected ? AppColors.primaryGreen : Colors.white,
                    size: 21,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected ? AppColors.primaryGreen : Colors.white,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
