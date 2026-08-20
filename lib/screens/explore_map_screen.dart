import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/features/explore_map/controllers/explore_map_cubit.dart';
import 'package:vngrocery/features/explore_map/controllers/explore_map_state.dart';
import 'package:vngrocery/features/explore_map/explore_map_presenter.dart';
import 'package:vngrocery/features/explore_map/widgets/explore_map_components.dart';
import 'package:vngrocery/widgets/osm_tile_map.dart';

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

/// Last resort when the reader declined location and no shop has coordinates.
const _fallbackCenter = GeoPoint(10.7769, 106.7009);

class _ExploreMapScreenState extends State<ExploreMapScreen> {
  late final ExploreMapCubit _mapCubit;

  @override
  void initState() {
    super.initState();
    _mapCubit = ExploreMapCubit(initialShopId: widget.initialShopId)
      ..load()
      ..locateReader();
  }

  @override
  void dispose() {
    _mapCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mapCubit,
      child: BlocBuilder<ExploreMapCubit, ExploreMapState>(
        builder: (context, state) {
          // Nearest first, and only what is actually in range.
          final shops = state.nearbyShops.map((entry) => entry.item).toList();
          final center = state.center;
          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: OsmTileMap(
                    // Falls back to the middle of Ho Chi Minh City only when
                    // there is neither a location nor a shop to centre on.
                    latitude: center?.latitude ?? _fallbackCenter.latitude,
                    longitude: center?.longitude ?? _fallbackCenter.longitude,
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
                    alignment:
                        ExploreMapPresenter.pinPositions[i %
                            ExploreMapPresenter.pinPositions.length],
                    child: FloatingShopPin(
                      shop: shops[i],
                      selected: shops[i].id == state.selectedShopId,
                      onTap: () => _mapCubit.selectShop(shops[i].id),
                    ),
                  ),
                Positioned(
                  right: 16,
                  bottom: MediaQuery.sizeOf(context).height * 0.32,
                  child: LocateUserButton(
                    onPressed: () async {
                      await _mapCubit.locateReader();
                      _mapCubit.selectNearestShop();
                    },
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.26,
                  minChildSize: 0.18,
                  maxChildSize: 0.58,
                  builder: (context, controller) {
                    return ExploreMapBottomSheet(
                      controller: controller,
                      shops: shops,
                      selectedShopId: state.selectedShopId,
                      onSelectShop: (shop) => _mapCubit.selectShop(shop.id),
                      selectedShop: state.selectedShop,
                      bottomContentInset: widget.bottomOverlayInset,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
