import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:vngrocery/core/services/food_ai_service.dart';
import 'package:vngrocery/features/scanner/widgets/scanner_components.dart';

class ScannerScreen extends StatefulWidget {
  final double bottomContentInset;

  const ScannerScreen({super.key, this.bottomContentInset = 0});

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

  @override
  void initState() {
    super.initState();
    _line = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw StateError('Không tìm thấy camera');
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

  Future<void> _captureAndPredict() async {
    final camera = _camera;
    if (_verifying || camera == null || !camera.value.isInitialized) return;
    setState(() => _verifying = true);
    try {
      final file = await camera.takePicture();
      final result = await FoodAiService.instance.predict(
        await file.readAsBytes(),
      );
      if (mounted) setState(() => _result = result);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('AI camera error: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  @override
  void dispose() {
    _camera?.dispose();
    _line.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      _cameraError ?? 'Đang mở camera...',
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
          ),
          Positioned(
            top: 64,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  color: Colors.white,
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
                    'Tin cậy: ${(_result!.freshnessConfidence! * 100).toStringAsFixed(1)}%',
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
