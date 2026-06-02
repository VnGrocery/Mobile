import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';

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
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.gray),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tìm cửa hàng gần bạn',
                      style: TextStyle(color: AppColors.textSecondary),
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
    return Material(
      color: context.palette.elevatedCard,
      elevation: 4,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: 'Vị trí của bạn',
        onPressed: onPressed,
        icon: const Icon(Icons.my_location, color: AppColors.primaryGreen),
      ),
    );
  }
}
