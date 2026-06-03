import 'dart:math' as math;

import 'package:flutter/material.dart';

class OsmTileMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final int zoom;

  const OsmTileMap({
    super.key,
    required this.latitude,
    required this.longitude,
    this.zoom = 13,
  });

  @override
  Widget build(BuildContext context) {
    final centerX = _lonToTileX(longitude, zoom);
    final centerY = _latToTileY(latitude, zoom);
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
                      'https://tile.openstreetmap.org/$zoom/${baseX + dx}/${baseY + dy}.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: Color(0xFFEAF6EF),
                      ),
                    ),
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

  double _latToTileY(double lat, int zoom) {
    final latRad = lat * math.pi / 180.0;
    return (1.0 - math.log(math.tan(latRad) + 1 / math.cos(latRad)) / math.pi) /
        2.0 *
        math.pow(2.0, zoom);
  }
}
