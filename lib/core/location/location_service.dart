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
  LocationService();

  static final LocationService instance = LocationService();

  /// The ask in flight, if any.
  ///
  /// MainScreen builds every tab at once, so the home tab, the store list and
  /// the map all ask on the same frame. The plugin answers the second overlap
  /// by throwing PermissionRequestInProgressException; they now share one
  /// request and one answer.
  Future<(ReaderLocation?, LocationDenial?)>? _inFlight;

  /// Asks for permission if it has not been decided yet, then reads a fix.
  ///
  /// Returns a [LocationDenial] rather than throwing: not knowing where the
  /// reader is degrades the ordering of a list, it does not break a screen.
  Future<(ReaderLocation?, LocationDenial?)> current() {
    return _inFlight ??= _guarded().whenComplete(() => _inFlight = null);
  }

  Future<(ReaderLocation?, LocationDenial?)> _guarded() async {
    try {
      return await _current();
    } on PermissionRequestInProgressException {
      // Two screens asked at once - the home tab on open and the map behind
      // it. The plugin refuses the second request by throwing, and this method
      // promises never to throw: not knowing where the reader is degrades an
      // ordering, it does not break a screen. The answer from the first
      // request arrives through the caller that made it.
      return (null, LocationDenial.unavailable);
    } catch (_) {
      // Any other platform failure - no location provider on the device, a
      // simulator with location off, a channel error - is the same answer.
      return (null, LocationDenial.unavailable);
    }
  }

  Future<(ReaderLocation?, LocationDenial?)> _current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return (null, LocationDenial.serviceOff);
    }

    var permission = await Geolocator.checkPermission();
    // The OS dialog can sit open for as long as the reader takes to answer
    // it, and the provider is only just starting up the instant they do -
    // the first fix right after saying yes is the one most likely to be
    // slow or momentarily empty. Nothing else on this screen asks again, so
    // one retry here beats a chip that never updates without a manual pull.
    final justGranted = permission == LocationPermission.denied;
    if (justGranted) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return (null, LocationDenial.blocked);
    }
    if (permission == LocationPermission.denied) {
      return (null, LocationDenial.denied);
    }

    var position = await _position();
    if (position == null && justGranted) {
      position = await _position();
    }
    if (position == null) return (null, LocationDenial.unavailable);

    final point = GeoPoint(position.latitude, position.longitude);
    return (
      ReaderLocation(point: point, areaName: await _areaName(point)),
      null,
    );
  }

  /// A fresh fix if one arrives quickly, otherwise the last one Android saw.
  ///
  /// Indoors — which is where someone browses a grocery app — a cold GPS fix
  /// can take longer than anyone will wait, or never arrive at all. The last
  /// known position puts the reader within a few hundred metres of where they
  /// are, which is ample for choosing between a 2 km shop and a 15 km one.
  /// Waiting for a perfect fix instead left the app claiming it had no idea.
  Future<Position?> _position() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          // Ranking by kilometres does not need a metre-accurate fix, and a
          // coarse one arrives far faster and costs much less battery.
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (_) {
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
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
