import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_palette.dart';

class AppFeedback {
  const AppFeedback._();

  static void showSnackBar(
    BuildContext context,
    String message, {
    IconData icon = Icons.check_circle_rounded,
  }) {
    final palette = context.palette;
    final media = MediaQuery.of(context);
    final bottomMargin = 102 + media.padding.bottom + media.viewInsets.bottom;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          duration: const Duration(milliseconds: 1800),
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.fromLTRB(20, 0, 20, bottomMargin),
          padding: EdgeInsets.zero,
          content: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.elevatedCard.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: palette.glassBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: AppColors.primaryGreen, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
