import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

/// Reads a bundle QR from the seller's label and hands the token back.
///
/// Pops with the parsed [BundleToken]; the caller decides what to do with it.
class QrScanScreen extends StatefulWidget {
  /// Pop the scanned text as-is instead of parsing it as a bundle token. Used
  /// for voucher codes, which are not bundle QRs.
  final bool raw;

  const QrScanScreen({super.key, this.raw = false});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );

  /// Set once a code has been accepted so the stream of detections cannot pop
  /// the route twice.
  bool _handled = false;
  String? _message;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value == null || value.isEmpty) continue;

      if (widget.raw) {
        _handled = true;
        Navigator.pop(context, value);
        return;
      }

      final l10n = AppLocalizations.of(context);
      final token = BundleToken.tryParse(value);

      if (token == null || !token.isUsable) {
        setState(() => _message = l10n.qrScanNotOurCode);
        return;
      }
      if (!token.isSupported) {
        setState(() => _message = l10n.qrScanUnsupported);
        return;
      }
      if (token.isExpired(DateTime.now().toUtc())) {
        setState(() => _message = l10n.qrScanExpired);
        return;
      }

      _handled = true;
      Navigator.pop(context, token);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(l10n.qrScanTitle),
        actions: [
          IconButton(
            onPressed: () => _controller.toggleTorch(),
            icon: const Icon(Icons.flash_on),
            tooltip: l10n.a11yToggleFlash,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '${l10n.qrScanCameraError}\n$error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const _ScanFrame(),
          Positioned(
            left: 24,
            right: 24,
            bottom: 64,
            child: Column(
              children: [
                Text(
                  _message ?? l10n.qrScanHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _message == null
                        ? Colors.white
                        : AppColors.warningOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanFrame extends StatelessWidget {
  const _ScanFrame();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryGreen, width: 3),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
