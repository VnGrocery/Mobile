import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import 'geo.dart';

/// Why the app has no position to rank by.
enum LocationDenial {
  /// The device's location switch is off.
  serviceOff,

  /// The reader said no. Asking again from here would be nagging; the OS
  /// settings screen is the only way back.
  denied,

  /// Denied permanently ("don't ask again") or blocked by policy.
  blocked,

  /// Permission was granted but no fix came back in time.
  unavailable,
}

/// Where the reader is, and what to call that place.
class ReaderLocation {
  final GeoPoint point;

  /// Human-readable area, e.g. "Quận 1". Empty when reverse geocoding failed —
  /// the coordinates are still usable for ranking.
  final String areaName;

  const ReaderLocation({required this.point, this.areaName = ''});
}

/// Reads the device position.
///
/// The home header used to print a hardcoded "Quận 1" for everyone, wherever
/// they were, and the map always opened on the centre of Ho Chi Minh City.
class LocationService {
  const LocationService();

  static const LocationService instance = LocationService();

  /// Asks for permission if it has not been decided yet, then reads a fix.
  ///
  /// Returns a [LocationDenial] rather than throwing: not knowing where the
  /// reader is degrades the ordering of a list, it does not break a screen.
  Future<(ReaderLocation?, LocationDenial?)> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return (null, LocationDenial.serviceOff);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return (null, LocationDenial.blocked);
    }
    if (permission == LocationPermission.denied) {
      return (null, LocationDenial.denied);
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          // Ranking by kilometres does not need a metre-accurate fix, and a
          // coarse one arrives far faster and costs much less battery.
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 12),
        ),
      );
      final point = GeoPoint(position.latitude, position.longitude);
      return (
        ReaderLocation(point: point, areaName: await _areaName(point)),
        null,
      );
    } catch (_) {
      return (null, LocationDenial.unavailable);
    }
  }

  /// Best available name for the district or ward containing [point].
  ///
  /// Empty on failure: the chip falls back to showing the coordinates' use
  /// rather than a wrong place name.
  Future<String> _areaName(GeoPoint point) async {
    try {
      final places = await geocoding.Geocoding().placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (places.isEmpty) return '';
      final place = places.first;
      for (final candidate in [
        place.subAdministrativeArea,
        place.locality,
        place.subLocality,
        place.administrativeArea,
      ]) {
        final name = candidate?.trim() ?? '';
        if (name.isNotEmpty) return name;
      }
      return '';
    } catch (_) {
      return '';
    }
  }
}
