import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _ExploreMapScreenState extends State<ExploreMapScreen> {
  late final ExploreMapCubit _mapCubit;

  @override
  void initState() {
    super.initState();
    _mapCubit = ExploreMapCubit(initialShopId: widget.initialShopId)..load();
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
          final shops = state.shops;
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
                    alignment:
                        ExploreMapPresenter.pinPositions[i %
                            ExploreMapPresenter.pinPositions.length],
                    child: FloatingShopPin(
                      shop: shops[i],
                      selected: shops[i].id == state.selectedShopId,
                      onTap: () => _mapCubit.selectShop(shops[i].id),
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
