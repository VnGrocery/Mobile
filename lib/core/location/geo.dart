import 'dart:math' as math;

/// A point on the map.
class GeoPoint {
  final double latitude;
  final double longitude;

  const GeoPoint(this.latitude, this.longitude);

  /// Shops that were saved without coordinates come back as exactly (0, 0),
  /// which is in the Atlantic — ranking by distance to it is meaningless.
  bool get isSet => latitude != 0 || longitude != 0;

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';
}

/// Great-circle distance in kilometres.
///
/// Straight-line rather than travel distance: the app only needs to say which
/// shop is nearer, and a routing service would be a network call per shop.
double distanceKm(GeoPoint from, GeoPoint to) {
  const earthRadiusKm = 6371.0088;

  final dLat = _radians(to.latitude - from.latitude);
  final dLon = _radians(to.longitude - from.longitude);
  final lat1 = _radians(from.latitude);
  final lat2 = _radians(to.latitude);

  final a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1) * math.cos(lat2);

  return earthRadiusKm * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

double _radians(double degrees) => degrees * math.pi / 180;
