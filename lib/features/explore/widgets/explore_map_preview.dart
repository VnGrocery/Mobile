import 'package:flutter/material.dart';

import '../../../data/models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';
import '../../../widgets/osm_tile_map.dart';

class ExploreMapPreview extends StatelessWidget {
  final List<Shop> shops;
  final String? selectedShopId;
  final VoidCallback onOpenMap;
  final ValueChanged<Shop> onSelectShop;

  const ExploreMapPreview({
    super.key,
    required this.shops,
    required this.selectedShopId,
    required this.onOpenMap,
    required this.onSelectShop,
  });

  static const _pinPositions = [
    Alignment(-0.68, -0.12),
    Alignment(0.54, -0.44),
    Alignment(0.08, 0.48),
    Alignment(-0.32, 0.30),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
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
                  child: const AbsorbPointer(
                    child: OsmTileMap(
                      latitude: 10.7769,
                      longitude: 106.7009,
                      zoom: 13,
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
              for (var i = 0; i < shops.length; i++)
                Align(
                  alignment: _pinPositions[i % _pinPositions.length],
                  child: MapPreviewPin(
                    shop: shops[i],
                    selected: shops[i].id == selectedShopId,
                    onTap: () => onSelectShop(shops[i]),
                  ),
                ),
              Positioned(
                right: 14,
                bottom: 14,
                child: Material(
                  color: palette.elevatedCard,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: 'Vị trí của bạn',
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
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.map, size: 16, color: AppColors.primaryGreen),
          SizedBox(width: 6),
          Text(
            'Mở bản đồ',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
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
