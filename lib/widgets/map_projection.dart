import 'package:flutter/widgets.dart';

import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/widgets/osm_tile_map.dart';

/// Turns coordinates into pixels inside a map viewport.
///
/// The pins on the map used to be dropped at four fixed alignments, so a shop
/// 300 m away and one 15 km away appeared side by side and moving the map
/// changed nothing. This is the same Web Mercator maths [OsmTileMap] uses to
/// place its tiles, kept in one place so a pin cannot drift from the tile it is
/// supposed to sit on.
class MapProjection {
  /// Point the viewport is centred on.
  final GeoPoint center;
  final int zoom;
  final Size viewport;

  const MapProjection({
    required this.center,
    required this.zoom,
    required this.viewport,
  });

  /// Edge length of one tile as drawn.
  ///
  /// [OsmTileMap] stretches its 4x4 grid so a tile covers half the longer side
  /// of the viewport; the projection has to agree with that or pins land in the
  /// wrong place.
  double get tileSize => OsmTileMap.tileSizeFor(viewport);

  /// Where [point] falls, in pixels from the viewport's top-left.
  ///
  /// The result can be outside the viewport; use [isVisible] to decide whether
  /// to draw it.
  Offset project(GeoPoint point) {
    final dx = _tileX(point.longitude) - _tileX(center.longitude);
    final dy = _tileY(point.latitude) - _tileY(center.latitude);

    return Offset(
      dx * tileSize + viewport.width / 2,
      dy * tileSize + viewport.height / 2,
    );
  }

  /// Whether a pin at [offset] would be on screen, allowing [margin] pixels so
  /// a marker straddling the edge is not dropped.
  bool isVisible(Offset offset, {double margin = 48}) {
    return offset.dx >= -margin &&
        offset.dy >= -margin &&
        offset.dx <= viewport.width + margin &&
        offset.dy <= viewport.height + margin;
  }

  /// Closest zoom at which every one of [points] is still on screen.
  ///
  /// Measured with this same projection rather than from a rule of thumb about
  /// how much ground a tile covers: [OsmTileMap] stretches each tile to half
  /// the longer side of the viewport, so the scale depends on the viewport's
  /// shape and a guessed constant put shops several screens off the edge.
  static int zoomToFit({
    required GeoPoint center,
    required List<GeoPoint> points,
    required Size viewport,
    int minZoom = 3,
    int maxZoom = 16,
  }) {
    final located = points.where((point) => point.isSet).toList();
    if (located.isEmpty || viewport.isEmpty) return maxZoom;

    for (var zoom = maxZoom; zoom > minZoom; zoom--) {
      final projection = MapProjection(
        center: center,
        zoom: zoom,
        viewport: viewport,
      );
      // No margin here: a pin must be comfortably inside, not clinging to the
      // edge where its label would be clipped.
      final fits = located.every(
        (point) => projection.isVisible(projection.project(point), margin: -72),
      );
      if (fits) return zoom;
    }
    return minZoom;
  }

  double _tileX(double longitude) => OsmTileMap.tileXOf(longitude, zoom);

  double _tileY(double latitude) => OsmTileMap.tileYOf(latitude, zoom);
}
