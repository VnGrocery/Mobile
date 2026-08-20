import 'package:flutter/material.dart';

import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/widgets/map_projection.dart';
import 'package:vngrocery/widgets/osm_tile_map.dart';

class ExploreMapPreview extends StatelessWidget {
  final List<Shop> shops;
  final String? selectedShopId;
  final VoidCallback onOpenMap;
  final ValueChanged<Shop> onSelectShop;

  /// Where to centre the preview. Null falls back to the middle of Ho Chi Minh
  /// City, which is what this always showed before, for everyone.
  final GeoPoint? center;

  const ExploreMapPreview({
    super.key,
    required this.shops,
    required this.selectedShopId,
    required this.onOpenMap,
    required this.onSelectShop,
    this.center,
  });

  static const _fallbackCenter = GeoPoint(10.7769, 106.7009);

  GeoPoint get mapCenter => center ?? _fallbackCenter;

  List<GeoPoint> get _points => [
    for (final shop in shops) GeoPoint(shop.latitude, shop.longitude),
  ];

  /// Close enough to show every shop that made it into the list; the viewport
  /// decides the scale, so its size has to be known first.
  int _zoomFor(Size viewport) => MapProjection.zoomToFit(
    center: mapCenter,
    points: _points,
    viewport: viewport,
  );

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return AspectRatio(
      aspectRatio: 1.95,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFEAF6EF),
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onOpenMap,
                  child: AbsorbPointer(
                    child: LayoutBuilder(
                      builder: (context, constraints) => OsmTileMap(
                        latitude: mapCenter.latitude,
                        longitude: mapCenter.longitude,
                        zoom: _zoomFor(
                          Size(constraints.maxWidth, constraints.maxHeight),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.16),
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(left: 16, top: 14, child: MapPreviewBadge()),
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final viewport = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                    return MapPreviewPinLayer(
                      shops: shops,
                      selectedShopId: selectedShopId,
                      onSelectShop: onSelectShop,
                      center: mapCenter,
                      zoom: _zoomFor(viewport),
                    );
                  },
                ),
              ),
              Positioned(
                right: 14,
                bottom: 14,
                child: Material(
                  color: palette.elevatedCard,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: l10n.exploreYourLocation,
                    onPressed: onOpenMap,
                    icon: const Icon(
                      Icons.my_location,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapPreviewBadge extends StatelessWidget {
  const MapPreviewBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.elevatedCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.map, size: 16, color: AppColors.primaryGreen),
          const SizedBox(width: 6),
          Text(
            AppLocalizations.of(context).exploreOpenMap,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// Places preview pins where the shops actually are.
///
/// They used to cycle through four fixed alignments, so the arrangement said
/// nothing about the city and every fifth shop landed on top of the first.
class MapPreviewPinLayer extends StatelessWidget {
  final List<Shop> shops;
  final String? selectedShopId;
  final ValueChanged<Shop> onSelectShop;
  final GeoPoint center;
  final int zoom;

  const MapPreviewPinLayer({
    super.key,
    required this.shops,
    required this.selectedShopId,
    required this.onSelectShop,
    required this.center,
    required this.zoom,
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
            for (final shop in shops)
              if (_visibleOffset(projection, shop) case final offset?)
                Positioned(
                  left: offset.dx - 60,
                  top: offset.dy - 34,
                  width: 120,
                  height: 34,
                  child: OverflowBox(
                    // Bottom-aligned so the tip of the marker lands on the
                    // coordinate rather than floating above it.
                    alignment: Alignment.bottomCenter,
                    maxWidth: 120,
                    maxHeight: 34,
                    child: MapPreviewPin(
                      shop: shop,
                      selected: shop.id == selectedShopId,
                      onTap: () => onSelectShop(shop),
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }

  /// Null for a shop with no coordinates or one scrolled off the preview.
  static Offset? _visibleOffset(MapProjection projection, Shop shop) {
    final point = GeoPoint(shop.latitude, shop.longitude);
    if (!point.isSet) return null;
    final offset = projection.project(point);
    return projection.isVisible(offset, margin: 24) ? offset : null;
  }
}

class MapPreviewPin extends StatelessWidget {
  final Shop shop;
  final bool selected;
  final VoidCallback onTap;

  const MapPreviewPin({
    super.key,
    required this.shop,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: selected ? 1.12 : 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 118),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: palette.elevatedCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? AppColors.primaryGreen : palette.border,
                  ),
                ),
                child: Text(
                  shop.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Icon(
              Icons.location_on,
              color: selected ? AppColors.priceRed : AppColors.primaryGreen,
              size: selected ? 34 : 30,
            ),
          ],
        ),
      ),
    );
  }
}
