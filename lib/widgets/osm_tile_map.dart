import 'dart:math' as math;

import 'package:flutter/material.dart';

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

class OsmTileMap extends StatelessWidget {
  static const minZoom = 0;
  static const maxZoom = 19;
  static const minLatitude = -85.05112878;
  static const maxLatitude = 85.05112878;

  final double latitude;
  final double longitude;
  final int zoom;
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
    final safeZoom = zoom.clamp(providerConfig.minZoom, providerConfig.maxZoom);
    final effectiveTileUriBuilder =
        tileUriBuilder ?? providerConfig.tileUriBuilder;
    final centerX = tileXOf(longitude, safeZoom);
    final centerY = tileYOf(latitude, safeZoom);
    final maxTile = math.pow(2, safeZoom).toInt() - 1;
    final baseX = centerX.floor() - 1;
    final baseY = centerY.floor() - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileSize = tileSizeFor(
          Size(constraints.maxWidth, constraints.maxHeight),
        );
        final offsetX = (centerX - centerX.floor()) * tileSize;
        final offsetY = (centerY - centerY.floor()) * tileSize;

        return ClipRect(
          child: Stack(
            children: [
              for (var dx = 0; dx < 4; dx++)
                for (var dy = 0; dy < 4; dy++)
                  Positioned(
                    left:
                        (dx - 1) * tileSize -
                        offsetX +
                        constraints.maxWidth / 2,
                    top:
                        (dy - 1) * tileSize -
                        offsetY +
                        constraints.maxHeight / 2,
                    width: tileSize,
                    height: tileSize,
                    child: Image.network(
                      effectiveTileUriBuilder(
                        safeZoom,
                        _wrapTileX(baseX + dx, safeZoom),
                        (baseY + dy).clamp(0, maxTile),
                      ).toString(),
                      semanticLabel: providerConfig.semanticLabel,
                      fit: BoxFit.cover,
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

  /// Tile-space x for a longitude. Shared with [MapProjection] so a pin and
  /// the tile under it cannot disagree about where a place is.
  static double tileXOf(double longitude, int zoom) {
    final wrapped = ((longitude + 180.0) % 360.0) - 180.0;
    return ((wrapped + 180.0) / 360.0) * math.pow(2.0, zoom);
  }

  /// Tile-space y for a latitude, clamped to what Web Mercator can express.
  static double tileYOf(double latitude, int zoom) {
    final clamped = latitude.clamp(minLatitude, maxLatitude).toDouble();
    final rad = clamped * math.pi / 180.0;
    return (1.0 - math.log(math.tan(rad) + 1 / math.cos(rad)) / math.pi) /
        2.0 *
        math.pow(2.0, zoom);
  }

  /// Edge length of one drawn tile: the 4x4 grid stretches so a tile covers
  /// half the longer side of the viewport.
  static double tileSizeFor(Size viewport) =>
      math.max(viewport.width, viewport.height) / 2;

  int _wrapTileX(int x, int zoom) {
    final tileCount = math.pow(2, zoom).toInt();
    return x.remainder(tileCount) < 0
        ? x.remainder(tileCount) + tileCount
        : x.remainder(tileCount);
  }
}

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
