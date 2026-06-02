import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class ScanDiamondButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const ScanDiamondButton({
    super.key,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        onTap: onTap,
        child: Transform.rotate(
          angle: 0.785398,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryGreenDark
                  : AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.34),
                  blurRadius: 34,
                  spreadRadius: 4,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Transform.rotate(
              angle: -0.785398,
              child: Icon(icon, color: Colors.white, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}
