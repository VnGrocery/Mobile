import 'package:flutter/material.dart';

import '../../data/data_hooks.dart';
import '../../data/models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common.dart';
import '../../widgets/osm_tile_map.dart';

class ExploreTab extends StatefulWidget {
  final bool showMap;
  final double bottomContentInset;

  const ExploreTab({
    super.key,
    this.showMap = true,
    this.bottomContentInset = 0,
  });

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final _search = TextEditingController();
  String _filter = 'Đánh giá tốt';
  String? _selectedShopId;

  static const _filters = [
    'Đánh giá tốt',
    'Có ghi nhận',
    'Gần bạn',
    'Mới nhất'
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final shops = AppDataHooks.instance.getShops().where((shop) {
      if (query.isEmpty) return true;
      return shop.name.toLowerCase().contains(query) ||
          shop.address.toLowerCase().contains(query);
    }).toList();
    final selectedShop = widget.showMap
        ? shops.where((shop) => shop.id == _selectedShopId).firstOrNull
        : null;

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: Text(
          widget.showMap ? 'Khám phá cửa hàng' : 'Cửa hàng',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() => _selectedShopId = null),
              decoration: const InputDecoration(
                hintText: 'Tìm tên cửa hàng hoặc địa chỉ...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.filter_list),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final filter = _filters[i];
                final selected = filter == _filter;
                return FilterChip(
                  label: Text(filter),
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: AppColors.meatRed.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: selected ? AppColors.meatRed : Colors.black,
                  ),
                  onSelected: (_) => setState(() => _filter = filter),
                );
              },
            ),
          ),
          SizedBox(height: widget.showMap ? 16 : 12),
          if (widget.showMap) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _ExploreMap(
                shops: shops,
                selectedShopId: selectedShop?.id,
                onOpenMap: () => Navigator.pushNamed(
                  context,
                  Routes.exploreMap,
                  arguments: selectedShop?.id,
                ),
                onSelectShop: (shop) =>
                    setState(() => _selectedShopId = shop.id),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  widget.showMap ? 'Cửa hàng gần bạn' : 'Tất cả cửa hàng',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (widget.showMap && selectedShop != null)
                  TextButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.storeDetail,
                      arguments: selectedShop.id,
                    ),
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Xem đường'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: shops.isEmpty
                ? const Center(
                    child: Text(
                      'Không tìm thấy cửa hàng phù hợp',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      4,
                      16,
                      16 + widget.bottomContentInset,
                    ),
                    itemCount: shops.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _ShopExploreCard(
                      shop: shops[i],
                      selected:
                          widget.showMap && shops[i].id == _selectedShopId,
                      onTap: () {
                        if (widget.showMap) {
                          setState(() => _selectedShopId = shops[i].id);
                          return;
                        }
                        Navigator.pushNamed(
                          context,
                          Routes.storeDetail,
                          arguments: shops[i].id,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ShopExploreCard extends StatelessWidget {
  final Shop shop;
  final bool selected;
  final VoidCallback onTap;

  const _ShopExploreCard({
    required this.shop,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? AppColors.trustGreenBg : AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? AppColors.primaryGreen : Colors.transparent,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: () => Navigator.pushNamed(
          context,
          Routes.storeDetail,
          arguments: shop.id,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const GrayBox(
                size: 70,
                radius: 12,
                icon: Icons.store,
                iconSize: 32,
                iconColor: AppColors.meatRed,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      shop.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.trustGreenBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppColors.warningOrange,
                                size: 12,
                              ),
                              Text(
                                ' ${shop.rating} điểm đánh giá',
                                style: const TextStyle(
                                  color: AppColors.trustGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (shop.reviewCount > 100)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.meatRed.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Đánh giá tốt',
                              style: TextStyle(
                                color: AppColors.meatRed,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                selected ? Icons.place : Icons.chevron_right,
                color: selected ? AppColors.primaryGreen : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreMap extends StatelessWidget {
  final List<Shop> shops;
  final String? selectedShopId;
  final VoidCallback onOpenMap;
  final ValueChanged<Shop> onSelectShop;

  const _ExploreMap({
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
                    child: const OsmTileMap(
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
              const Positioned(left: 16, top: 14, child: _MapBadge()),
              for (var i = 0; i < shops.length; i++)
                Align(
                  alignment: _pinPositions[i % _pinPositions.length],
                  child: _MapPin(
                    shop: shops[i],
                    selected: shops[i].id == selectedShopId,
                    onTap: () => onSelectShop(shops[i]),
                  ),
                ),
              Positioned(
                right: 14,
                bottom: 14,
                child: Material(
                  color: Colors.white,
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

class _MapBadge extends StatelessWidget {
  const _MapBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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

class _MapPin extends StatelessWidget {
  final Shop shop;
  final bool selected;
  final VoidCallback onTap;

  const _MapPin({
    required this.shop,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? AppColors.primaryGreen : Colors.white,
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
