import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:vngrocery/core/services/camera_devices.dart';
import 'package:vngrocery/core/services/food_ai_service.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/scanner/widgets/scanner_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/screens/qr_scan_screen.dart';

class ScannerScreen extends StatefulWidget {
  final double bottomContentInset;

  /// Whether this tab is the one on screen.
  ///
  /// The tabs live in an IndexedStack, so this screen is built as soon as the
  /// app starts. Opening the camera there kept it powered for the whole
  /// session, which pinned the camera HAL at 60% CPU and made the app hang.
  final bool active;

  /// Called when the close (X) button is tapped.
  ///
  /// This screen lives as a tab inside the buyer's IndexedStack, so it is not
  /// a pushed route. Calling Navigator.pop here would pop the MainScreen route
  /// itself and strand the app on the cancelled-route/blank screen. When a
  /// callback is supplied (the tab case) it switches back to a real tab
  /// instead; when it is null (opened as the `scan` route) the button falls
  /// back to popping the route it was actually pushed on.
  final VoidCallback? onClose;

  const ScannerScreen({
    super.key,
    this.bottomContentInset = 0,
    this.active = true,
    this.onClose,
  });

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _line;
  CameraController? _camera;
  FoodAiResult? _result;
  bool _verifying = false;
  String? _cameraError;
  bool _noCamera = false;

  /// Bundle scanned from a seller label. Without it the photo can only be
  /// classified locally; the server needs the token to check it against a
  /// pledge.
  BundleToken? _bundle;

  @override
  void initState() {
    super.initState();
    _line = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.active) _startScanning();
  }

  @override
  void didUpdateWidget(covariant ScannerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active == oldWidget.active) return;
    if (widget.active) {
      _startScanning();
    } else {
      _stopScanning();
    }
  }

  /// The camera was already tied to the tab being visible. The scan line was
  /// not: it began turning in [initState] and never stopped, and because this
  /// screen is built up front inside the IndexedStack it kept turning behind
  /// every other tab for as long as the app was open. A ticker that never
  /// stops asks for a frame on every vsync, so the app never went idle — the
  /// raster thread ran flat out drawing a line nobody was looking at.
  void _startScanning() {
    if (!_line.isAnimating) _line.repeat();
    _initCamera();
  }

  void _stopScanning() {
    _line.stop();
    _closeCamera();
  }

  Future<void> _closeCamera() async {
    final camera = _camera;
    _camera = null;
    if (mounted) setState(() {});
    await camera?.dispose();
  }

  Future<void> _initCamera() async {
    if (_camera != null) return;
    try {
      final cameras = await cachedCameras();
      // Localised where it is shown, not here: reading context after an await
      // is unsafe.
      if (cameras.isEmpty) {
        if (mounted) setState(() => _noCamera = true);
        return;
      }
      final camera = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await camera.initialize();
      if (!mounted) {
        await camera.dispose();
        return;
      }
      _camera = camera;
      setState(() {});
    } catch (error) {
      if (mounted) setState(() => _cameraError = error.toString());
    }
  }

  Future<void> _scanCode() async {
    final token = await Navigator.push<BundleToken>(
      context,
      MaterialPageRoute(builder: (_) => const QrScanScreen()),
    );
    if (token == null || !mounted) return;
    setState(() => _bundle = token);
  }

  Future<void> _captureAndPredict() async {
    final camera = _camera;
    if (_verifying || camera == null || !camera.value.isInitialized) return;
    setState(() => _verifying = true);
    try {
      final file = await camera.takePicture();
      final bytes = await file.readAsBytes();

      // Always classify locally so the user sees something even offline.
      final result = await FoodAiService.instance.predict(bytes);
      if (mounted) setState(() => _result = result);

      await _sendBuyerCheck(bytes);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('AI camera error: $error')));
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  /// Sends the captured photo to the server to be compared against the pledge
  /// named by the scanned code. Skipped when nothing has been scanned yet.
  Future<void> _sendBuyerCheck(Uint8List bytes) async {
    final bundle = _bundle;
    final repositories = AppRepositories.instance;
    final remote = repositories.pledges.remote;
    if (bundle == null || remote == null) return;

    final l10n = AppLocalizations.of(context);
    try {
      final result = await remote.buyerCheck(
        bytes: bytes,
        pledgeId: bundle.pledgeId,
        bundleId: bundle.bundleId,
        bundleToken: bundle.raw,
      );
      repositories.buyerChecks.setResult(
        BuyerCheckResult.fromJson(result),
        productId: result['productId']?.toString(),
      );
      if (!mounted) return;
      // The token is single use, so it cannot be reused for another photo.
      setState(() => _bundle = null);
      Navigator.pushNamed(context, Routes.buyerCheckResult);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${l10n.qrScanChecking} $error')));
    }
  }

  /// Handles the close (X) button.
  ///
  /// As a tab this screen sits at the root of the navigator, so popping would
  /// tear down MainScreen and land the app on the blank cancelled-route
  /// screen. The [ScannerScreen.onClose] callback switches back to another tab
  /// instead. When opened as the pushed `scan` route there is no callback, so
  /// it pops that route safely.
  void _handleClose() {
    final onClose = widget.onClose;
    if (onClose != null) {
      onClose();
      return;
    }
    Navigator.of(context).maybePop();
  }

  @override
  void dispose() {
    _camera?.dispose();
    _line.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      key: const ValueKey('scanner.screen'),
      backgroundColor: Colors.black,
      body: Stack(
        key: const ValueKey('scanner.stack'),
        children: [
          Positioned.fill(
            child: _camera?.value.isInitialized == true
                ? CameraPreview(_camera!)
                : Center(
                    child: Text(
                      _noCamera
                          ? l10n.scannerNoCamera
                          : _cameraError ?? l10n.scannerOpeningCamera,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
          ScannerBody(
            scanLine: _line,
            verifying: _verifying,
            bottomContentInset: widget.bottomContentInset,
            onSimulate: _captureAndPredict,
            onScanCode: _scanCode,
            scannedBundleId: _bundle?.bundleId,
          ),
          Positioned(
            // Was a hardcoded 64: on a phone with a taller status bar or a
            // display cutout the controls crept under the system chrome.
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _handleClose,
                  color: Colors.white,
                  tooltip: l10n.a11yCloseCamera,
                  icon: const Icon(Icons.close),
                ),
                IconButton(
                  onPressed: _camera?.value.isInitialized == true
                      ? () => _camera!.setFlashMode(
                          _camera!.value.flashMode == FlashMode.off
                              ? FlashMode.torch
                              : FlashMode.off,
                        )
                      : null,
                  color: Colors.white,
                  tooltip: l10n.a11yToggleFlash,
                  icon: const Icon(Icons.flash_on),
                ),
              ],
            ),
          ),
          if (_result != null)
            Positioned(
              left: 24,
              right: 24,
              bottom: 24 + widget.bottomContentInset,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '${_result!.category} · ${_result!.freshness}\n'
                    '${l10n.scannerConfidenceValue((_result!.freshnessConfidence! * 100).toStringAsFixed(1))}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
