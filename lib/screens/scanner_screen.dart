import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:vngrocery/core/network/api_exception.dart';
import 'package:vngrocery/core/services/camera_devices.dart';
import 'package:vngrocery/core/services/food_ai_service.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/buyer_check/buyer_check_presenter.dart';
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

class _ScannerScreenState extends State<ScannerScreen> {
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
    if (widget.active) _initCamera();
  }

  @override
  void didUpdateWidget(covariant ScannerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active == oldWidget.active) return;
    if (widget.active) {
      _initCamera();
    } else {
      _closeCamera();
    }
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
    // A printed crate label carries only the lot code, so there is nothing to
    // check a photo against. It answers a different question - what did the
    // seller pledge for this lot - so it opens the record instead.
    if (token.isLotCode) {
      await _openLot(token.bundleId);
      return;
    }
    setState(() => _bundle = token);
  }

  Future<void> _openLot(String lotCode) async {
    final remote = AppRepositories.instance.pledges.remote;
    final l10n = AppLocalizations.of(context);
    if (remote == null) {
      _showMessage(l10n.lotLookupFailed);
      return;
    }
    setState(() => _verifying = true);
    try {
      final pledge = await remote.bundleByLotCode(lotCode);
      final productId = pledge['productId']?.toString() ?? '';
      final shopId = pledge['shopId']?.toString() ?? '';
      if (!mounted) return;
      if (productId.isEmpty || shopId.isEmpty) {
        _showMessage(l10n.lotLookupFailed);
        return;
      }
      Navigator.pushNamed(
        context,
        Routes.productDetail,
        arguments: ProductDetailArgs(shopId: shopId, productId: productId),
      );
    } catch (error) {
      if (!mounted) return;
      _showMessage(
        error is ApiException && error.statusCode == 404
            ? l10n.lotNotFound
            : l10n.lotLookupFailed,
      );
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  /// Takes the photo and sends it to be checked against the scanned code.
  ///
  /// The on-device model runs too, but only as a courtesy: it used to run
  /// first, and because it throws when a model is missing it took the server
  /// check down with it, burning the single-use token for nothing.
  Future<void> _captureAndCheck() async {
    final bytes = await _capture();
    if (bytes == null) return;
    setState(() => _verifying = true);
    try {
      await _sendBuyerCheck(bytes);
      await _predictLocally(bytes, announceFailure: false);
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  /// Classifies a photo on the phone without sending it anywhere.
  Future<void> _captureAndAnalyse() async {
    final bytes = await _capture();
    if (bytes == null) return;
    setState(() => _verifying = true);
    try {
      await _predictLocally(bytes, announceFailure: true);
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  /// Returns the photo bytes, or null when the shutter itself failed.
  Future<Uint8List?> _capture() async {
    final camera = _camera;
    if (_verifying || camera == null || !camera.value.isInitialized) {
      return null;
    }
    try {
      final file = await camera.takePicture();
      return await file.readAsBytes();
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context).scannerCaptureFailed);
      }
      return null;
    }
  }

  Future<void> _predictLocally(
    Uint8List bytes, {
    required bool announceFailure,
  }) async {
    try {
      final result = await FoodAiService.instance.predict(bytes);
      if (mounted) setState(() => _result = result);
    } catch (_) {
      // The model is a convenience, not the record. Naming the exception would
      // put a Dart stack trace in front of someone standing at a market stall.
      if (mounted && announceFailure) {
        _showMessage(AppLocalizations.of(context).scannerLocalAiFailed);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(BuyerCheckPresenter.errorMessage(error, l10n))),
      );
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
                // Cover rather than stretch: filling the box directly squashed
                // the preview, so what the person framed was not the shape of
                // the photo they got.
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _camera!.value.previewSize!.height,
                      height: _camera!.value.previewSize!.width,
                      child: CameraPreview(_camera!),
                    ),
                  )
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
          // The controls are white on whatever the camera happens to see. Over
          // a pale crate of produce the title and hints disappeared entirely.
          const Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.black26, Colors.black87],
                    stops: [0, 0.35, 1],
                  ),
                ),
              ),
            ),
          ),
          ScannerBody(
            verifying: _verifying,
            bottomContentInset: widget.bottomContentInset,
            onCapture: _captureAndCheck,
            onAnalyseOnDevice: _captureAndAnalyse,
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
