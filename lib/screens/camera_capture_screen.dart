import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

/// Takes one photo and returns its bytes.
///
/// Pledges and reviews used to upload a bundled picture of meat, so every
/// freshness score in the system was derived from the same image. This is the
/// shared way to get a real one.
class CameraCaptureScreen extends StatefulWidget {
  /// Shown above the shutter to say what should be in frame.
  final String? hint;

  const CameraCaptureScreen({super.key, this.hint});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _camera;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _error = 'no_camera');
        return;
      }
      final controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _camera = controller);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  @override
  void dispose() {
    _camera?.dispose();
    super.dispose();
  }

  Future<void> _shoot() async {
    final camera = _camera;
    if (_busy || camera == null || !camera.value.isInitialized) return;
    setState(() => _busy = true);
    try {
      final file = await camera.takePicture();
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      Navigator.pop<Uint8List>(context, bytes);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ready = _camera?.value.isInitialized == true;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(l10n.cameraCaptureTitle),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (ready)
            CameraPreview(_camera!)
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _error == null
                      ? l10n.scannerOpeningCamera
                      : _error == 'no_camera'
                      ? l10n.scannerNoCamera
                      : '${l10n.qrScanCameraError}\n$_error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: Column(
              children: [
                if (widget.hint != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      widget.hint!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                    ),
                    onPressed: ready && !_busy ? _shoot : null,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(l10n.cameraCaptureAction),
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
