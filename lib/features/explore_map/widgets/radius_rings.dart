import 'package:flutter/material.dart';

import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/location/nearby.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/widgets/map_projection.dart';

/// Draws the two distances the app searches within, around the reader.
///
/// The list says shops are "near you" and quietly widens from 5 km to 20 km
/// when the inner ring is empty. Without something on the map saying so, the
/// reader has no way to see how far "near" reaches or why a shop they know of
/// is missing.
class RadiusRings extends StatelessWidget {
  final GeoPoint center;
  final MapProjection projection;

  const RadiusRings({
    super.key,
    required this.center,
    required this.projection,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _RingPainter(
          origin: projection.project(center),
          metresPerPixel: projection.metresPerPixel,
          textDirection: Directionality.of(context),
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final Offset origin;
  final double metresPerPixel;
  final TextDirection textDirection;

  const _RingPainter({
    required this.origin,
    required this.metresPerPixel,
    required this.textDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (metresPerPixel <= 0) return;

    // Solid for the ring the app prefers, dashed for the one it only falls back
    // to, so the two read as different promises rather than two equal circles.
    _drawRing(canvas, size, NearbyRadius.near, dashed: false, alpha: 0.55);
    _drawRing(canvas, size, NearbyRadius.far, dashed: true, alpha: 0.35);
  }

  void _drawRing(
    Canvas canvas,
    Size size,
    double km, {
    required bool dashed,
    required double alpha,
  }) {
    final radius = km * 1000 / metresPerPixel;
    // Zoomed far out the rings collapse into the dot; zoomed far in they are
    // off screen in every direction. Neither is worth drawing.
    if (radius < 12 || radius > size.longestSide * 6) return;

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColors.primaryGreen.withValues(alpha: alpha);

    if (dashed) {
      _strokeDashedCircle(canvas, radius, stroke);
    } else {
      canvas.drawCircle(origin, radius, stroke);
      canvas.drawCircle(
        origin,
        radius,
        Paint()..color = AppColors.primaryGreen.withValues(alpha: 0.06),
      );
    }

    _drawLabel(canvas, size, km, radius, alpha);
  }

  /// Flutter has no dashed stroke, so the circle is drawn as a run of arcs.
  void _strokeDashedCircle(Canvas canvas, double radius, Paint paint) {
    const dashRadians = 0.09;
    const gapRadians = 0.06;
    final rect = Rect.fromCircle(center: origin, radius: radius);

    for (var start = 0.0; start < 6.2832; start += dashRadians + gapRadians) {
      canvas.drawArc(rect, start, dashRadians, false, paint);
    }
  }

  /// Written on the ring itself rather than in a legend, so the number is
  /// attached to the circle it describes.
  void _drawLabel(
    Canvas canvas,
    Size size,
    double km,
    double radius,
    double alpha,
  ) {
    final label = TextPainter(
      text: TextSpan(
        text: '${km.toStringAsFixed(0)} km',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryGreen.withValues(alpha: alpha + 0.35),
        ),
      ),
      textDirection: textDirection,
    )..layout();

    // Sitting on top of the circle, just above the line.
    final at = Offset(origin.dx - label.width / 2, origin.dy - radius - 16);
    if (at.dy < 0 || at.dy > size.height) return;

    final background = RRect.fromRectAndRadius(
      Rect.fromLTWH(at.dx - 5, at.dy - 2, label.width + 10, label.height + 4),
      const Radius.circular(8),
    );
    canvas.drawRRect(background, Paint()..color = Colors.white70);
    label.paint(canvas, at);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.origin != origin ||
      oldDelegate.metresPerPixel != metresPerPixel;
}
