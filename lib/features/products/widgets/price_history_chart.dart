import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// The price over the last window, drawn from the same signed record as the
/// change log above it.
///
/// Every point is a recorded change, not a sample: the line steps because a
/// price holds until someone changes it, and each step corresponds to an entry
/// whose hash is on screen.
class PriceHistoryChart extends StatelessWidget {
  final ProductHistory history;

  const PriceHistoryChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.show_chart,
                size: 18,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.productPriceChartTitle(history.windowDays),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!history.hasPriceMovement)
            // A flat line says nothing a sentence does not say better.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                l10n.productPriceChartFlat(history.windowDays),
                style: TextStyle(
                  fontSize: 12,
                  color: context.palette.textSecondary,
                ),
              ),
            )
          else ...[
            // A CustomPaint announces nothing at all to a screen reader; the
            // range is the part of this chart a person can actually act on.
            Semantics(
              image: true,
              label: l10n.a11yPriceChart(
                history.windowDays,
                formatVnd(history.lowestPrice.round()),
                formatVnd(history.highestPrice.round()),
              ),
              child: SizedBox(
                height: 130,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _PriceLinePainter(
                    points: history.priceHistory,
                    line: AppColors.primaryGreen,
                    grid: palette.mutedSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Flexible: at a large system font scale the two bounds together
            // grew wider than the card and overflowed the row.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _Bound(
                    label: formatVnd(history.lowestPrice.round()),
                    caption: '↓',
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: _Bound(
                    label: formatVnd(history.highestPrice.round()),
                    caption: '↑',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Bound extends StatelessWidget {
  final String label;
  final String caption;

  const _Bound({required this.label, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$caption $label',
      style: TextStyle(fontSize: 11, color: context.palette.textSecondary),
    );
  }
}

class _PriceLinePainter extends CustomPainter {
  final List<PricePoint> points;
  final Color line;
  final Color grid;

  const _PriceLinePainter({
    required this.points,
    required this.line,
    required this.grid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2 || size.isEmpty) return;

    final firstAt = points.first.at.millisecondsSinceEpoch;
    final lastAt = points.last.at.millisecondsSinceEpoch;
    final span = (lastAt - firstAt).toDouble();

    var lowest = points.first.price;
    var highest = points.first.price;
    for (final point in points) {
      lowest = point.price < lowest ? point.price : lowest;
      highest = point.price > highest ? point.price : highest;
    }
    // A little headroom so the extremes are not drawn on the border.
    final range = (highest - lowest).abs();
    final padding = range == 0 ? 1.0 : range * 0.15;
    lowest -= padding;
    highest += padding;

    double x(PricePoint point) {
      if (span <= 0) return size.width;
      return (point.at.millisecondsSinceEpoch - firstAt) / span * size.width;
    }

    double y(PricePoint point) {
      final ratio = (point.price - lowest) / (highest - lowest);
      return size.height - ratio * size.height;
    }

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      Paint()
        ..color = grid
        ..strokeWidth = 1,
    );

    // Stepped, because a price holds at its value until the next recorded
    // change; sloping between points would draw movement nobody recorded.
    final path = Path()..moveTo(x(points.first), y(points.first));
    for (var i = 1; i < points.length; i++) {
      path.lineTo(x(points[i]), y(points[i - 1]));
      path.lineTo(x(points[i]), y(points[i]));
    }

    final fill = Path.from(path)
      ..lineTo(x(points.last), size.height)
      ..lineTo(x(points.first), size.height)
      ..close();
    canvas.drawPath(fill, Paint()..color = line.withValues(alpha: 0.10));

    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );

    // A dot per recorded change, so the reader can count them against the
    // entries in the log above.
    for (final point in points) {
      canvas.drawCircle(Offset(x(point), y(point)), 3.5, Paint()..color = line);
      canvas.drawCircle(
        Offset(x(point), y(point)),
        1.6,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(_PriceLinePainter oldDelegate) =>
      oldDelegate.points != points;
}
