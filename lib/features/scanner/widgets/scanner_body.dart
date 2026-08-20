import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';

import 'scanner_frame.dart';
import 'scanner_status_pill.dart';

class ScannerBody extends StatelessWidget {
  final Animation<double> scanLine;
  final bool verifying;
  final double bottomContentInset;
  final VoidCallback onSimulate;

  /// Opens the QR reader. Null hides the action, e.g. when there is no backend
  /// to check against.
  final VoidCallback? onScanCode;

  /// Bundle already scanned in this session, shown so the user knows the photo
  /// will be checked against it.
  final String? scannedBundleId;

  const ScannerBody({
    super.key,
    required this.scanLine,
    required this.verifying,
    required this.bottomContentInset,
    required this.onSimulate,
    this.onScanCode,
    this.scannedBundleId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            ScannerFrame(scanLine: scanLine),
            const SizedBox(height: 40),
            ScannerStatusPill(verifying: verifying),
            if (scannedBundleId != null) ...[
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
            ElevatedButton(
              key: const ValueKey('scanner.simulate_scan_button'),
              onPressed: verifying ? null : onSimulate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(220, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                verifying
                    ? l10n.scannerCheckingAction
                    : l10n.scannerSimulateAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
