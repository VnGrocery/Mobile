import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/osm_tile_map.dart';

class ExploreMapScreen extends StatefulWidget {
  final String? initialShopId;

  const ExploreMapScreen({super.key, this.initialShopId});

  @override
  State<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends State<ExploreMapScreen> {
  late String? _selectedShopId = widget.initialShopId;

  static const _pinPositions = [
    Alignment(-0.62, -0.18),
    Alignment(0.58, -0.42),
    Alignment(0.10, 0.34),
    Alignment(-0.42, 0.46),
  ];

  @override
  Widget build(BuildContext context) {
    final shops = AppDataHooks.instance.getShops();
    final selectedShop = shops.where((shop) => shop.id == _selectedShopId).firstOrNull;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: const OsmTileMap(
              latitude: 10.7769,
              longitude: 106.7009,
              zoom: 13,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: MediaQuery.paddingOf(context).top + 12,
            child: _SearchShell(onBack: () => Navigator.pop(context)),
          ),
          for (var i = 0; i < shops.length; i++)
            Align(
              alignment: _pinPositions[i % _pinPositions.length],
              child: _FloatingShopPin(
                shop: shops[i],
                selected: shops[i].id == _selectedShopId,
                onTap: () => setState(() => _selectedShopId = shops[i].id),
              ),
            ),
          Positioned(
            right: 16,
            bottom: 238,
            child: Material(
              color: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: 'Vị trí của bạn',
                onPressed: () {},
                icon: const Icon(
                  Icons.my_location,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.26,
            minChildSize: 0.18,
            maxChildSize: 0.58,
            builder: (context, controller) {
              return _MapBottomSheet(
                controller: controller,
                shops: shops,
                selectedShopId: _selectedShopId,
                onSelectShop: (shop) => setState(() => _selectedShopId = shop.id),
                selectedShop: selectedShop,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SearchShell extends StatelessWidget {
  final VoidCallback onBack;

  const _SearchShell({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          elevation: 4,
          shape: const CircleBorder(),
          child: IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Material(
            color: Colors.white,
            elevation: 4,
            borderRadius: BorderRadius.circular(24),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.gray),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tìm cửa hàng gần bạn',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  Icon(Icons.tune, color: AppColors.primaryGreen),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FloatingShopPin extends StatelessWidget {
  final Shop shop;
  final bool selected;
  final VoidCallback onTap;

  const _FloatingShopPin({
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
        scale: selected ? 1.16 : 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              Container(
                constraints: const BoxConstraints(maxWidth: 150),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  shop.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            Icon(
              Icons.location_on,
              color: selected ? AppColors.priceRed : AppColors.primaryGreen,
              size: selected ? 42 : 34,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapBottomSheet extends StatelessWidget {
  final ScrollController controller;
  final List<Shop> shops;
  final String? selectedShopId;
  final ValueChanged<Shop> onSelectShop;
  final Shop? selectedShop;

  const _MapBottomSheet({
    required this.controller,
    required this.shops,
    required this.selectedShopId,
    required this.onSelectShop,
    required this.selectedShop,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD8D8D8),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Cửa hàng gần bạn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (selectedShop != null)
                FilledButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.storeDetail,
                    arguments: selectedShop!.id,
                  ),
                  child: const Text('Xem cửa hàng'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...shops.map(
            (shop) => _MapShopTile(
              shop: shop,
              selected: shop.id == selectedShopId,
              onTap: () => onSelectShop(shop),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapShopTile extends StatelessWidget {
  final Shop shop;
  final bool selected;
  final VoidCallback onTap;

  const _MapShopTile({
    required this.shop,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? AppColors.trustGreenBg : AppColors.card,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    selected ? Icons.place : Icons.storefront,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        shop.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 15, color: AppColors.warningOrange),
                    Text(
                      ' ${shop.rating}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
