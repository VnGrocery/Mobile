import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';

class SellerPledgeCaptureStep extends StatelessWidget {
  final bool analyzing;
  final VoidCallback onCapture;

  const SellerPledgeCaptureStep({
    super.key,
    required this.analyzing,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 350,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              l10n.sellerPledgeCameraPreview,
              style: const TextStyle(color: Color(0xFF555555)),
            ),
          ),
        ),
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
