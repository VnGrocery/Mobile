import 'package:camera/camera.dart';

/// Cached result of [availableCameras].
///
/// The device's camera list cannot change during the app's lifetime, but the
/// plugin call is a platform channel round trip that costs real time on
/// hardware. The scanner tab and the pledge/product capture screen each
/// re-enumerated it on every open; caching it once means only the very first
/// open anywhere in the app pays that cost.
Future<List<CameraDescription>>? _camerasFuture;

Future<List<CameraDescription>> cachedCameras() {
  return _camerasFuture ??= availableCameras();
}
