import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerPledgeCaptureStep extends StatelessWidget {
  final bool analyzing;

  /// Why the last photo could not be scored, in the reader's language.
  final String? failure;
  final VoidCallback onCapture;

  const SellerPledgeCaptureStep({
    super.key,
    required this.analyzing,
    required this.onCapture,
    this.failure,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Not a camera. It used to be a black rectangle with the words
        // "camera preview" in it, which read as a camera that had failed to
        // start - the real one opens full screen when the button is tapped.
        Container(
          height: 280,
          decoration: BoxDecoration(
            color: context.palette.mutedSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.photo_camera_outlined,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.pledgeCaptureHint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (failure != null) ...[
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error_outline,
                size: 20,
                color: AppColors.warningOrange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  failure!,
                  style: const TextStyle(
                    color: AppColors.warningOrange,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 32),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: analyzing ? null : onCapture,
            child: analyzing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.photo_camera),
                      const SizedBox(width: 12),
                      Text(
                        l10n.sellerPledgeCaptureAction,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
