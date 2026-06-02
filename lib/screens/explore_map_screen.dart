import 'package:flutter/material.dart';

import '../core/ui/app_feedback.dart';
import '../data/models.dart';
import '../features/explore/explore_presenter.dart';
import '../features/explore_map/explore_map_presenter.dart';
import '../features/explore_map/widgets/explore_map_components.dart';
import '../widgets/osm_tile_map.dart';

class ExploreMapScreen extends StatefulWidget {
  final String? initialShopId;
  final bool showBackButton;
  final double bottomOverlayInset;

  const ExploreMapScreen({
    super.key,
    this.initialShopId,
    this.showBackButton = true,
    this.bottomOverlayInset = 0,
  });

  @override
  State<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends State<ExploreMapScreen> {
  late String? _selectedShopId = widget.initialShopId;

  @override
  Widget build(BuildContext context) {
    final shops = ExplorePresenter.shops();
    final selectedShop = ExplorePresenter.selectedShop(shops, _selectedShopId);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: OsmTileMap(
              latitude: 10.7769,
              longitude: 106.7009,
              zoom: 13,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: MediaQuery.paddingOf(context).top + 12,
            child: ExploreSearchShell(
              showBackButton: widget.showBackButton,
              onBack: () => Navigator.pop(context),
            ),
          ),
          for (var i = 0; i < shops.length; i++)
            Align(
              alignment: ExploreMapPresenter
                  .pinPositions[i % ExploreMapPresenter.pinPositions.length],
              child: FloatingShopPin(
                shop: shops[i],
                selected: shops[i].id == _selectedShopId,
                onTap: () => setState(() => _selectedShopId = shops[i].id),
              ),
            ),
          Positioned(
            right: 16,
            bottom: 238,
            child: LocateUserButton(onPressed: () => _locateUser(shops)),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.26,
            minChildSize: 0.18,
            maxChildSize: 0.58,
            builder: (context, controller) {
              return ExploreMapBottomSheet(
                controller: controller,
                shops: shops,
                selectedShopId: _selectedShopId,
                onSelectShop: (shop) =>
                    setState(() => _selectedShopId = shop.id),
                selectedShop: selectedShop,
                bottomContentInset: widget.bottomOverlayInset,
              );
            },
          ),
        ],
      ),
    );
  }

  void _locateUser(List<Shop> shops) {
    if (shops.isNotEmpty) {
      setState(() => _selectedShopId = shops.first.id);
    }
    AppFeedback.showSnackBar(context, 'Đã căn về vị trí gần bạn (demo)');
  }
}
