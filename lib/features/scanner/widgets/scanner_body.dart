import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';

import 'scanner_frame.dart';
import 'scanner_status_pill.dart';

class ScannerBody extends StatelessWidget {
  final bool verifying;
  final double bottomContentInset;

  /// Takes the photo and sends it to be checked against the scanned code.
  ///
  /// This is the plain capture. The screen used to offer only the on-device
  /// analysis, so the one thing the server can actually verify was reachable
  /// only through a model that had to succeed first.
  final VoidCallback onCapture;

  /// Takes a photo and classifies it on the phone, without sending anything.
  final VoidCallback onAnalyseOnDevice;

  /// Opens the QR reader. Null hides the action, e.g. when there is no backend
  /// to check against.
  final VoidCallback? onScanCode;

  /// Bundle already scanned in this session, shown so the user knows the photo
  /// will be checked against it.
  final String? scannedBundleId;

  const ScannerBody({
    super.key,
    required this.verifying,
    required this.bottomContentInset,
    required this.onCapture,
    required this.onAnalyseOnDevice,
    this.onScanCode,
    this.scannedBundleId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Without a scanned code there is no pledge to compare the photo against,
    // so sending it would be a silent no-op. Say so instead.
    final canCheck = scannedBundleId != null;
    return Center(
      key: const ValueKey('scanner.body'),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomContentInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.accountScanProducts,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.scannerFrameHint,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            const ScannerFrame(),
            const SizedBox(height: 40),
            ScannerStatusPill(verifying: verifying),
            if (canCheck) ...[
              const SizedBox(height: 8),
              Text(
                scannedBundleId!,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (onScanCode != null) ...[
              OutlinedButton.icon(
                key: const ValueKey('scanner.scan_code_button'),
                onPressed: verifying ? null : onScanCode,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  minimumSize: const Size(220, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(l10n.qrScanTitle),
              ),
              const SizedBox(height: 10),
            ],
            ElevatedButton.icon(
              key: const ValueKey('scanner.capture_button'),
              onPressed: verifying || !canCheck ? null : onCapture,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                // Spelled out because the default disabled pair is derived from
                // the light theme's onSurface: over the camera preview it came
                // out as grey on dark and the main action read as absent
                // rather than as waiting for a code.
                disabledBackgroundColor: Colors.white24,
                disabledForegroundColor: Colors.white70,
                minimumSize: const Size(220, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(Icons.camera_alt),
              label: Text(
                verifying
                    ? l10n.scannerCheckingAction
                    : l10n.scannerCaptureAction,
              ),
            ),
            if (!canCheck) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: 260,
                child: Text(
                  l10n.scannerNeedsCodeHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 4),
            TextButton(
              key: const ValueKey('scanner.simulate_scan_button'),
              onPressed: verifying ? null : onAnalyseOnDevice,
              style: TextButton.styleFrom(foregroundColor: Colors.white70),
              child: Text(l10n.scannerSimulateAction),
            ),
          ],
        ),
      ),
    );
  }
}
