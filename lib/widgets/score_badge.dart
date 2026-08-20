import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/utils/format.dart';

const _defaultLabel = 'Điểm đánh giá';

class ScoreRingBadge extends StatelessWidget {
  /// On the server's 0-10 scale.
  final double score;
  final double size;
  final double strokeWidth;
  final String label;
  final double scoreFontSize;
  final double labelFontSize;

  const ScoreRingBadge({
    super.key,
    required this.score,
    this.size = 48,
    this.strokeWidth = 2,
    this.label = _defaultLabel,
    this.scoreFontSize = 18,
    this.labelFontSize = 9,
  });

  @override
  Widget build(BuildContext context) {
    final scoreColor = scoreTrustColor(score);
    final resolvedLabel = label == _defaultLabel
        ? AppLocalizations.of(context).scoreBadgeLabel
        : label;
    return SizedBox(
      width: size + 26,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: ScoreRingPainter(
                progress: score.clamp(0, maxScore) / maxScore,
                color: scoreColor,
                strokeWidth: strokeWidth,
              ),
              child: Center(
                child: Text(
                  formatRating(score),
                  style: TextStyle(
                    color: scoreColor,
                    fontSize: scoreFontSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            resolvedLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF8E8E93),
              fontSize: labelFontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  const ScoreRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScoreRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Top of the freshness scale. The server validates pledge scores as 0-10 and
/// sends product scores on the same scale; the widgets here used to divide by
/// 100, which drew a 9.2 as a nearly empty ring in red.
const double maxScore = 10;

Color scoreTrustColor(double value) {
  if (value >= 9) return AppColors.primaryGreen;
  if (value >= 7) return AppColors.warningOrange;
  return AppColors.priceRed;
}
