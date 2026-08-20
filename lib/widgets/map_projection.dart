import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:vngrocery/core/location/geo.dart';

/// Edge length of a map tile as the tile server publishes it.
const double mapTileSize = 256;

/// Converts between coordinates and pixels for one view of the map.
///
/// Pins used to be dropped at four fixed alignments, so a shop 300 m away and
/// one 15 km away appeared side by side. This is the standard Web Mercator
/// projection, shared by the tile layer, the pins and the radius rings so none
/// of them can disagree about where a place is.
@immutable
class MapProjection {
  /// Coordinate at the centre of [viewport].
  final GeoPoint center;

  /// Fractional so a pinch can scale smoothly between tile levels.
  final double zoom;
  final Size viewport;

  const MapProjection({
    required this.center,
    required this.zoom,
    required this.viewport,
  });

  /// Width of the whole world in pixels at this zoom.
  double get worldSize => mapTileSize * math.pow(2, zoom);

  /// Ground distance one pixel covers, at the centre's latitude.
  ///
  /// Mercator stretches east-west distances away from the equator, so this
  /// depends on where you are looking as well as how far in.
  double get metresPerPixel {
    const equatorMetres = 40075016.686;
    return equatorMetres *
        math.cos(_radians(center.latitude.clamp(minLatitude, maxLatitude))) /
        worldSize;
  }

  /// Absolute position of a coordinate in whole-world pixels, before the
  /// viewport is taken into account. The tile grid is indexed by these.
  Offset worldPixels(GeoPoint point) =>
      Offset(_worldX(point.longitude), _worldY(point.latitude));

  /// World pixels of the viewport's top-left corner.
  Offset get originWorldPixels =>
      worldPixels(center) - Offset(viewport.width / 2, viewport.height / 2);

  /// Where [point] falls, in pixels from the viewport's top-left. The result
  /// can be outside the viewport; [isVisible] says whether to draw it.
  Offset project(GeoPoint point) => Offset(
    _worldX(point.longitude) - _worldX(center.longitude) + viewport.width / 2,
    _worldY(point.latitude) - _worldY(center.latitude) + viewport.height / 2,
  );

  /// The coordinate under a point on screen. Used to keep the place under a
  /// finger pinned to it while dragging or pinching.
  GeoPoint unproject(Offset offset) {
    final worldX = _worldX(center.longitude) + offset.dx - viewport.width / 2;
    final worldY = _worldY(center.latitude) + offset.dy - viewport.height / 2;

    final longitude = worldX / worldSize * 360.0 - 180.0;
    final n = math.pi - 2 * math.pi * worldY / worldSize;
    final latitude = 180.0 / math.pi * math.atan(_sinh(n));

    return GeoPoint(latitude, _wrapLongitude(longitude));
  }

  /// Whether a marker at [offset] would be on screen, allowing [margin] pixels
  /// so one straddling the edge is not dropped. A negative margin demands the
  /// marker be comfortably inside.
  bool isVisible(Offset offset, {double margin = 48}) {
    return offset.dx >= -margin &&
        offset.dy >= -margin &&
        offset.dx <= viewport.width + margin &&
        offset.dy <= viewport.height + margin;
  }

  MapProjection copyWith({GeoPoint? center, double? zoom, Size? viewport}) =>
      MapProjection(
        center: center ?? this.center,
        zoom: zoom ?? this.zoom,
        viewport: viewport ?? this.viewport,
      );

  /// Closest zoom at which every one of [points] is still on screen.
  ///
  /// Measured with this same projection rather than from a rule of thumb about
  /// how much ground a tile covers, which put shops two kilometres away several
  /// screens off the edge.
  static double zoomToFit({
    required GeoPoint center,
    required List<GeoPoint> points,
    required Size viewport,
    double minZoom = 3,
    double maxZoom = 17,
  }) {
    final located = points.where((point) => point.isSet).toList();
    if (located.isEmpty || viewport.isEmpty) return maxZoom;

    for (var zoom = maxZoom; zoom > minZoom; zoom -= 1) {
      final projection = MapProjection(
        center: center,
        zoom: zoom,
        viewport: viewport,
      );
      // Negative margin: a pin must sit comfortably inside, not cling to the
      // edge where its label would be clipped.
      final fits = located.every(
        (point) => projection.isVisible(projection.project(point), margin: -72),
      );
      if (fits) return zoom;
    }
    return minZoom;
  }

  double _worldX(double longitude) =>
      (_wrapLongitude(longitude) + 180.0) / 360.0 * worldSize;

  double _worldY(double latitude) {
    final rad = _radians(latitude.clamp(minLatitude, maxLatitude).toDouble());
    return (1.0 - math.log(math.tan(rad) + 1 / math.cos(rad)) / math.pi) /
        2.0 *
        worldSize;
  }

  static double _wrapLongitude(double longitude) =>
      ((longitude + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;

  static double _radians(num degrees) => degrees * math.pi / 180;

  static double _sinh(double x) => (math.exp(x) - math.exp(-x)) / 2;

  /// Web Mercator cannot represent the poles.
  static const double minLatitude = -85.05112878;
  static const double maxLatitude = 85.05112878;
}
