import 'dart:math' as math;

import 'package:flutter/material.dart';

class OsmTileMap extends StatelessWidget {
  static const minZoom = 0;
  static const maxZoom = 19;
  static const minLatitude = -85.05112878;
  static const maxLatitude = 85.05112878;

  final double latitude;
  final double longitude;
  final int zoom;
  final Uri Function(int zoom, int x, int y) tileUriBuilder;

  const OsmTileMap({
    super.key,
    required this.latitude,
    required this.longitude,
    this.zoom = 13,
    this.tileUriBuilder = defaultTileUriBuilder,
  });

  static Uri defaultTileUriBuilder(int zoom, int x, int y) {
    return Uri.https('tile.openstreetmap.org', '/$zoom/$x/$y.png');
  }

  @override
  Widget build(BuildContext context) {
    final safeZoom = zoom.clamp(minZoom, maxZoom);
    final centerX = _lonToTileX(_wrapLongitude(longitude), safeZoom);
    final centerY = _latToTileY(
      latitude.clamp(minLatitude, maxLatitude).toDouble(),
      safeZoom,
    );
    final maxTile = math.pow(2, safeZoom).toInt() - 1;
    final baseX = centerX.floor() - 1;
    final baseY = centerY.floor() - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileSize =
            math.max(constraints.maxWidth, constraints.maxHeight) / 2;
        final offsetX = (centerX - centerX.floor()) * tileSize;
        final offsetY = (centerY - centerY.floor()) * tileSize;

        return ClipRect(
          child: Stack(
            children: [
              for (var dx = 0; dx < 4; dx++)
                for (var dy = 0; dy < 4; dy++)
                  Positioned(
                    left: (dx - 1) * tileSize -
                        offsetX +
                        constraints.maxWidth / 2,
                    top: (dy - 1) * tileSize -
                        offsetY +
                        constraints.maxHeight / 2,
                    width: tileSize,
                    height: tileSize,
                    child: Image.network(
                      tileUriBuilder(
                        safeZoom,
                        _wrapTileX(baseX + dx, safeZoom),
                        (baseY + dy).clamp(0, maxTile),
                      ).toString(),
                      semanticLabel: 'OpenStreetMap tile',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _MapTileError(),
                    ),
                  ),
              const Positioned(
                right: 8,
                bottom: 6,
                child: _OsmAttribution(),
              ),
            ],
          ),
        );
      },
    );
  }

  double _lonToTileX(double lon, int zoom) {
    return ((lon + 180.0) / 360.0) * math.pow(2.0, zoom);
  }

  int _wrapTileX(int x, int zoom) {
    final tileCount = math.pow(2, zoom).toInt();
    return x.remainder(tileCount) < 0
        ? x.remainder(tileCount) + tileCount
        : x.remainder(tileCount);
  }

  double _wrapLongitude(double lon) {
    return ((lon + 180.0) % 360.0) - 180.0;
  }

  double _latToTileY(double lat, int zoom) {
    final latRad = lat * math.pi / 180.0;
    return (1.0 - math.log(math.tan(latRad) + 1 / math.cos(latRad)) / math.pi) /
        2.0 *
        math.pow(2.0, zoom);
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
  const _OsmAttribution();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          '© OpenStreetMap contributors',
          style: TextStyle(fontSize: 10, color: Color(0xFF355241)),
        ),
      ),
    );
  }
}
