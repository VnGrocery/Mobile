import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_colors.dart';

/// Explains why the home tab has nothing on it.
///
/// The tab used to render a section heading with an empty gap under it, both
/// when the server had nothing and when it could not be reached — two very
/// different problems that looked identical and neither of which the reader
/// could act on.
class HomeStatusMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  /// Only offered when retrying can actually change the outcome.
  final String? actionLabel;
  final VoidCallback? onAction;

  const HomeStatusMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 48),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              icon: const Icon(Icons.refresh),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
