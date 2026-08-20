import 'package:flutter/material.dart';

import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/explore_map/widgets/explore_map_pins.dart';
import 'package:vngrocery/widgets/map_projection.dart';

/// Places a pin over the map at each shop's real coordinates.
///
/// Pins used to sit at four fixed alignments, cycled through, so the same four
/// spots were used no matter where the shops actually were: a stall 300 m away
/// and one 15 km away appeared next to each other, two shops on the same street
/// appeared at opposite corners, and every fifth shop landed exactly on top of
/// the first.
class ShopPinLayer extends StatelessWidget {
  final List<Shop> shops;
  final String? selectedShopId;
  final ValueChanged<Shop> onSelect;

  /// What the map underneath is centred on.
  final GeoPoint center;
  final int zoom;

  /// Marker for the reader's own position, drawn when they have been located.
  final GeoPoint? readerAt;

  const ShopPinLayer({
    super.key,
    required this.shops,
    required this.selectedShopId,
    required this.onSelect,
    required this.center,
    required this.zoom,
    this.readerAt,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final projection = MapProjection(
          center: center,
          zoom: zoom,
          viewport: Size(constraints.maxWidth, constraints.maxHeight),
        );

        return Stack(
          clipBehavior: Clip.none,
          children: [
            if (readerAt != null && readerAt!.isSet)
              _positioned(
                projection,
                readerAt!,
                const _ReaderDot(),
                width: 22,
                height: 22,
              ),
            for (final shop in shops)
              if (_pointOf(shop) case final point?)
                _positioned(
                  projection,
                  point,
                  FloatingShopPin(
                    shop: shop,
                    selected: shop.id == selectedShopId,
                    onTap: () => onSelect(shop),
                  ),
                  // The pin is drawn above its anchor, so the tip sits on the
                  // coordinate rather than the label floating over it.
                  width: 132,
                  height: 76,
                  anchorAtBottom: true,
                ),
          ],
        );
      },
    );
  }

  static GeoPoint? _pointOf(Shop shop) {
    final point = GeoPoint(shop.latitude, shop.longitude);
    // A shop saved without an address sits at (0, 0) in the Atlantic; it gets
    // no pin rather than one in the wrong ocean. It is still in the list below.
    return point.isSet ? point : null;
  }

  Widget _positioned(
    MapProjection projection,
    GeoPoint point,
    Widget child, {
    required double width,
    required double height,
    bool anchorAtBottom = false,
  }) {
    final offset = projection.project(point);
    if (!projection.isVisible(offset)) return const SizedBox.shrink();

    return Positioned(
      left: offset.dx - width / 2,
      top: anchorAtBottom ? offset.dy - height : offset.dy - height / 2,
      width: width,
      height: height,
      // Align, not OverflowBox: OverflowBox only raises the maximum and leaves
      // the tight minimum from Positioned in place, so the marker was stretched
      // to fill the reserved height and its children packed at the top — the
      // tip landed 42 px above the coordinate instead of on it.
      //
      // The box is taller than the marker to leave room for the label a
      // selected pin grows upwards.
      child: Align(
        alignment: anchorAtBottom ? Alignment.bottomCenter : Alignment.center,
        child: child,
      ),
    );
  }
}

/// The reader's own position: a plain dot, visibly not a shop.
class _ReaderDot extends StatelessWidget {
  const _ReaderDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A73E8),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 6, spreadRadius: 1),
        ],
      ),
    );
  }
}
