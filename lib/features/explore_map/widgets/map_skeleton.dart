import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

/// Stands in for the map while the app works out where the reader is.
///
/// The map used to open immediately on whichever shop came first in the list,
/// which looks like a deliberate choice of somewhere else. Better to show
/// nothing in particular, and say why, than to show the wrong place
/// confidently.
class MapSkeleton extends StatefulWidget {
  const MapSkeleton({super.key});

  @override
  State<MapSkeleton> createState() => _MapSkeletonState();
}

class _MapSkeletonState extends State<MapSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Tones borrowed from the tiles this stands in for — land, roads,
    // buildings — rather than from the app's card palette, where the surface
    // and the card are near enough the same grey that the streets vanished.
    final dark = Theme.of(context).brightness == Brightness.dark;
    final land = dark ? const Color(0xFF20261F) : const Color(0xFFE9EDE6);
    final road = dark ? const Color(0xFF2E362C) : Colors.white;
    final building = dark ? const Color(0xFF394236) : const Color(0xFFD8DCD2);

    return ColoredBox(
      color: land,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _shimmer,
              builder: (context, _) => CustomPaint(
                painter: _SkeletonPainter(
                  progress: _shimmer.value,
                  road: road,
                  building: building,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.mapLocatingTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.mapLocatingMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A suggestion of streets and blocks, so the space reads as a map that has not
/// arrived rather than as an empty panel.
class _SkeletonPainter extends CustomPainter {
  /// 0 to 1, sweeping the highlight across.
  final double progress;
  final Color road;
  final Color building;

  const _SkeletonPainter({
    required this.progress,
    required this.road,
    required this.building,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final blockPaint = Paint()..color = building;
    final linePaint = Paint()
      ..color = road
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    // A loose grid, deliberately uneven so it does not read as graph paper.
    const columns = [0.18, 0.46, 0.78];
    const rows = [0.22, 0.52, 0.84];

    for (final x in columns) {
      canvas.drawLine(
        Offset(size.width * x, 0),
        Offset(size.width * x, size.height),
        linePaint,
      );
    }
    for (final y in rows) {
      canvas.drawLine(
        Offset(0, size.height * y),
        Offset(size.width, size.height * y),
        linePaint,
      );
    }

    for (final block in const [
      Rect.fromLTWH(0.24, 0.28, 0.16, 0.18),
      Rect.fromLTWH(0.54, 0.60, 0.18, 0.16),
      Rect.fromLTWH(0.02, 0.60, 0.12, 0.18),
      Rect.fromLTWH(0.56, 0.06, 0.18, 0.12),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            block.left * size.width,
            block.top * size.height,
            block.width * size.width,
            block.height * size.height,
          ),
          const Radius.circular(10),
        ),
        blockPaint,
      );
    }

    // The sweep that says this is loading rather than broken.
    final sweep = size.width * 2 * progress - size.width / 2;
    canvas.drawRect(
      Rect.fromLTWH(sweep, 0, size.width / 2, size.height),
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.28),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(sweep, 0, size.width / 2, size.height)),
    );
  }

  @override
  bool shouldRepaint(_SkeletonPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
