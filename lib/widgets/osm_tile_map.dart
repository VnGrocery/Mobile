import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/widgets/map_projection.dart';

class OsmTileProviderConfig {
  final Uri Function(int zoom, int x, int y) tileUriBuilder;
  final String attribution;
  final int minZoom;
  final int maxZoom;
  final String semanticLabel;

  const OsmTileProviderConfig({
    required this.tileUriBuilder,
    required this.attribution,
    required this.minZoom,
    required this.maxZoom,
    this.semanticLabel = 'OpenStreetMap tile',
  });

  static const openStreetMap = OsmTileProviderConfig(
    tileUriBuilder: OsmTileMap.defaultTileUriBuilder,
    attribution: '© OpenStreetMap contributors',
    minZoom: 0,
    maxZoom: 19,
  );
}

/// Draws the map tiles covering a viewport.
///
/// Was a fixed 4x4 grid with each tile stretched to half the longer side of the
/// viewport, which made the imagery blurry and tied the scale to the widget's
/// shape. It now lays tiles out at their true size through [MapProjection], so
/// the same maths places the tiles, the pins and the radius rings.
class OsmTileMap extends StatelessWidget {
  static const minZoom = 0;
  static const maxZoom = 19;
  static const minLatitude = MapProjection.minLatitude;
  static const maxLatitude = MapProjection.maxLatitude;

  final double latitude;
  final double longitude;

  /// Fractional zoom. Tiles come from the nearest whole level and are scaled to
  /// the remainder, so a pinch moves smoothly instead of jumping a level.
  final double zoom;
  final OsmTileProviderConfig providerConfig;
  final Uri Function(int zoom, int x, int y)? tileUriBuilder;

  const OsmTileMap({
    super.key,
    required this.latitude,
    required this.longitude,
    this.zoom = 13,
    this.providerConfig = OsmTileProviderConfig.openStreetMap,
    @Deprecated('Use providerConfig instead.') this.tileUriBuilder,
  });

  static Uri defaultTileUriBuilder(int zoom, int x, int y) {
    return Uri.https('tile.openstreetmap.org', '/$zoom/$x/$y.png');
  }

  @override
  Widget build(BuildContext context) {
    final safeZoom = zoom.clamp(
      providerConfig.minZoom.toDouble(),
      providerConfig.maxZoom.toDouble(),
    );
    final effectiveTileUriBuilder =
        tileUriBuilder ?? providerConfig.tileUriBuilder;

    // Whole level the images come from; the remainder becomes their scale.
    final tileZoom = safeZoom.round().clamp(
      providerConfig.minZoom,
      providerConfig.maxZoom,
    );
    final drawnTileSize = mapTileSize * math.pow(2, safeZoom - tileZoom);
    final tileCount = math.pow(2, tileZoom).toInt();

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = Size(constraints.maxWidth, constraints.maxHeight);
        final projection = MapProjection(
          center: GeoPoint(latitude, longitude),
          zoom: safeZoom,
          viewport: viewport,
        );

        // Where the viewport's top-left corner sits in the world, which is what
        // decides which tiles are on screen at all.
        final origin = projection.originWorldPixels;

        // Each tile covers drawnTileSize of those pixels, so the corner lands
        // inside tile (firstX, firstY).
        final firstX = (origin.dx / drawnTileSize).floor();
        final firstY = (origin.dy / drawnTileSize).floor();
        final columns = (viewport.width / drawnTileSize).ceil() + 1;
        final rows = (viewport.height / drawnTileSize).ceil() + 1;

        return ClipRect(
          child: Stack(
            children: [
              // Tiles arrive over the network one by one and show nothing at
              // all until each one lands, so the map was bare white for as
              // long as that took — several seconds on a slow connection, with
              // the pins and the radius ring already drawn on top of nothing.
              // Filling first gives an unlabelled map to fill in rather than a
              // hole.
              const Positioned.fill(child: ColoredBox(color: _tilePlaceholder)),
              for (var dx = 0; dx < columns; dx++)
                for (var dy = 0; dy < rows; dy++)
                  if (_tileY(firstY + dy, tileCount) case final tileY?)
                    Positioned(
                      left: (firstX + dx) * drawnTileSize - origin.dx,
                      top: (firstY + dy) * drawnTileSize - origin.dy,
                      width: drawnTileSize,
                      height: drawnTileSize,
                      child: Image.network(
                        effectiveTileUriBuilder(
                          tileZoom,
                          _wrapTileX(firstX + dx, tileCount),
                          tileY,
                        ).toString(),
                        semanticLabel: providerConfig.semanticLabel,
                        fit: BoxFit.cover,
                        // Fading in stops a half-loaded grid from flashing as
                        // a patchwork of hard-edged squares.
                        frameBuilder: (_, child, frame, wasSynchronous) {
                          if (wasSynchronous || frame != null) {
                            return AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(milliseconds: 180),
                              child: child,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        errorBuilder: (_, __, ___) => const _MapTileError(),
                      ),
                    ),
              Positioned(
                right: 8,
                bottom: 6,
                child: _OsmAttribution(providerConfig.attribution),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Longitude wraps around the globe, so a tile column past the edge is the
  /// one on the far side.
  static int _wrapTileX(int x, int tileCount) {
    final wrapped = x.remainder(tileCount);
    return wrapped < 0 ? wrapped + tileCount : wrapped;
  }

  /// Latitude does not wrap: past the poles there is simply no tile.
  static int? _tileY(int y, int tileCount) =>
      y < 0 || y >= tileCount ? null : y;
}

/// The colour of unlabelled land in the OpenStreetMap style, so a tile that has
/// not arrived reads as map rather than as a gap.
const Color _tilePlaceholder = Color(0xFFF2EFE9);

class _MapTileError extends StatelessWidget {
  const _MapTileError();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFEAF6EF),
      child: Center(
        child: Icon(
          Icons.map_outlined,
          color: Color(0xFF6B8F7A),
          size: 18,
          semanticLabel: 'Map tile unavailable',
        ),
      ),
    );
  }
}

class _OsmAttribution extends StatelessWidget {
  final String attribution;

  const _OsmAttribution(this.attribution);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          attribution,
          style: const TextStyle(fontSize: 10, color: Color(0xFF355241)),
        ),
      ),
    );
  }
}
