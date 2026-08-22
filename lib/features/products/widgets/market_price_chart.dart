import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// What every shop selling the same product charges, against this shop's price.
///
/// The chart above says how this shop's price moved. That says nothing about
/// whether it is fair, which is the question a shopper actually has. Two lines
/// answer it: the market average, and this shop.
class MarketPriceChart extends StatelessWidget {
  final MarketPrice market;

  /// This shop's own series, drawn against the average.
  final List<PricePoint> shopHistory;

  /// The price on the listing right now.
  final double shopPrice;

  final int windowDays;

  const MarketPriceChart({
    super.key,
    required this.market,
    required this.shopHistory,
    required this.shopPrice,
    required this.windowDays,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    if (!market.hasComparison) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.balance,
                size: 18,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.marketPriceTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _StandingChip(market: market, shopPrice: shopPrice),
            ],
          ),
          const SizedBox(height: 2),
          // Says how many shops the average rests on, so the reader can judge
          // how much it is worth.
          Text(
            l10n.marketPriceBasis(market.shopCount),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          // The average and the spread stand on their own; the chart only
          // appears once the average has actually moved over time.
          if (market.hasTrend) ...[
            SizedBox(
              height: 130,
              child: CustomPaint(
                size: Size.infinite,
                painter: _ComparisonPainter(
                  market: market.history,
                  shop: shopHistory,
                  marketColour: AppColors.primaryGreen,
                  shopColour: AppColors.priceRed,
                  grid: palette.mutedSurface,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _Legend(
                  colour: AppColors.primaryGreen,
                  label: l10n.marketPriceAverageLabel,
                ),
                const SizedBox(width: 14),
                _Legend(
                  colour: AppColors.priceRed,
                  label: l10n.marketPriceThisShopLabel,
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          // The spread, because an average alone can hide one shop charging
          // double.
          Text(
            l10n.marketPriceRange(
              formatVnd(market.currentLowest.round()),
              formatVnd(market.currentHighest.round()),
            ),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Where this shop stands against the average, in one phrase.
class _StandingChip extends StatelessWidget {
  final MarketPrice market;
  final double shopPrice;

  const _StandingChip({required this.market, required this.shopPrice});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final relative = market.relativeTo(shopPrice);
    if (relative == null) return const SizedBox.shrink();

    final percent = (relative.abs() * 100).round();
    // Under two per cent is noise, not a saving; calling it one would be
    // selling a rounding error as a bargain.
    final inline = percent < 2;
    final cheaper = relative < 0;

    final label = inline
        ? l10n.marketPriceInline
        : cheaper
        ? l10n.marketPriceCheaper(percent)
        : l10n.marketPriceDearer(percent);

    final colour = inline
        ? AppColors.textSecondary
        : cheaper
        ? AppColors.primaryGreen
        : AppColors.warningOrange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: inline ? palette.mutedSurface : palette.positiveBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: colour,
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color colour;
  final String label;

  const _Legend({required this.colour, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 3,
          decoration: BoxDecoration(
            color: colour,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// Draws both series on one pair of axes.
///
/// They share a scale on purpose: two lines on separate scales would let a
/// shop charging far above the market look level with it.
class _ComparisonPainter extends CustomPainter {
  final List<PricePoint> market;
  final List<PricePoint> shop;
  final Color marketColour;
  final Color shopColour;
  final Color grid;

  const _ComparisonPainter({
    required this.market,
    required this.shop,
    required this.marketColour,
    required this.shopColour,
    required this.grid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (market.length < 2 || size.isEmpty) return;

    final all = [...market, ...shop];
    var firstAt = all.first.at.millisecondsSinceEpoch;
    var lastAt = all.first.at.millisecondsSinceEpoch;
    var lowest = all.first.price;
    var highest = all.first.price;
    for (final point in all) {
      final at = point.at.millisecondsSinceEpoch;
      if (at < firstAt) firstAt = at;
      if (at > lastAt) lastAt = at;
      if (point.price < lowest) lowest = point.price;
      if (point.price > highest) highest = point.price;
    }

    final span = (lastAt - firstAt).toDouble();
    final range = (highest - lowest).abs();
    final padding = range == 0 ? 1.0 : range * 0.15;
    lowest -= padding;
    highest += padding;

    double x(PricePoint point) => span <= 0
        ? size.width
        : (point.at.millisecondsSinceEpoch - firstAt) / span * size.width;
    double y(PricePoint point) =>
        size.height - (point.price - lowest) / (highest - lowest) * size.height;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      Paint()
        ..color = grid
        ..strokeWidth = 1,
    );

    _drawStepped(canvas, size, market, marketColour, x, y, fill: true);
    if (shop.length >= 2) {
      _drawStepped(canvas, size, shop, shopColour, x, y, fill: false);
    }
  }

  /// Stepped, because a price holds at its value until the next recorded
  /// change; sloping between points would draw movement nobody recorded.
  void _drawStepped(
    Canvas canvas,
    Size size,
    List<PricePoint> points,
    Color colour,
    double Function(PricePoint) x,
    double Function(PricePoint) y, {
    required bool fill,
  }) {
    final path = Path()..moveTo(x(points.first), y(points.first));
    for (var i = 1; i < points.length; i++) {
      path.lineTo(x(points[i]), y(points[i - 1]));
      path.lineTo(x(points[i]), y(points[i]));
    }

    if (fill) {
      final area = Path.from(path)
        ..lineTo(x(points.last), size.height)
        ..lineTo(x(points.first), size.height)
        ..close();
      canvas.drawPath(area, Paint()..color = colour.withValues(alpha: 0.08));
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = colour
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_ComparisonPainter oldDelegate) =>
      oldDelegate.market != market || oldDelegate.shop != shop;
}
