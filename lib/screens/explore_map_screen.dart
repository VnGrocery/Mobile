import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/location/nearby.dart';
import 'package:vngrocery/features/explore_map/controllers/explore_map_cubit.dart';
import 'package:vngrocery/features/explore_map/controllers/explore_map_state.dart';
import 'package:vngrocery/features/explore_map/widgets/explore_map_components.dart';
import 'package:vngrocery/features/explore_map/widgets/shop_pin_layer.dart';
import 'package:vngrocery/widgets/map_projection.dart';
import 'package:vngrocery/features/explore_map/widgets/radius_rings.dart';
import 'package:vngrocery/widgets/interactive_map.dart';

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
  final _mapController = MapCameraController();

  @override
  void initState() {
    super.initState();
    _mapCubit = ExploreMapCubit(initialShopId: widget.initialShopId)
      ..load()
      ..locateReader();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _mapCubit.close();
    super.dispose();
  }

  /// Reads the GPS again and brings the map back to the reader.
  ///
  /// The move is commanded rather than left to a changed starting camera: once
  /// the reader has been located, locating them again yields the same point, so
  /// nothing about the state changes and the map would sit where it was
  /// dragged to.
  Future<void> _recentreOnReader() async {
    await _mapCubit.locateReader();
    if (!mounted) return;

    final origin = _mapCubit.state.origin;
    if (origin != null) _mapController.moveTo(origin);
    _mapCubit.selectNearestShop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mapCubit,
      child: BlocBuilder<ExploreMapCubit, ExploreMapState>(
        builder: (context, state) {
          // Nearest first, and only what is actually in range.
          final shops = state.nearbyShops.map((entry) => entry.item).toList();
          final center = state.center ?? _fallbackCenter;
          final points = [
            for (final shop in shops) GeoPoint(shop.latitude, shop.longitude),
            // Frame the ring the app searches within, not just the shops it
            // found: with nothing nearby the map would otherwise open at full
            // zoom on an empty street, showing neither.
            if (state.origin case final origin?) ...[
              offsetKm(origin, northKm: NearbyRadius.near),
              offsetKm(origin, northKm: -NearbyRadius.near),
              offsetKm(origin, eastKm: NearbyRadius.near),
              offsetKm(origin, eastKm: -NearbyRadius.near),
            ],
          ];
          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final viewport = Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );
                      // Pull back only as far as needed to fit every nearby
                      // shop, rather than opening at a fixed zoom that might
                      // show none of them. The viewport decides the scale, so
                      // this has to happen where its size is known.
                      final camera = MapCamera(
                        center: center,
                        zoom: MapProjection.zoomToFit(
                          center: center,
                          points: points,
                          viewport: viewport,
                        ),
                      );

                      return InteractiveMap(
                        initialCamera: camera,
                        controller: _mapController,
                        overlayBuilder: (context, projection) => Stack(
                          children: [
                            if (state.origin case final origin?)
                              Positioned.fill(
                                child: RadiusRings(
                                  center: origin,
                                  projection: projection,
                                ),
                              ),
                            Positioned.fill(
                              child: ShopPinLayer(
                                shops: shops,
                                selectedShopId: state.selectedShopId,
                                onSelect: (shop) =>
                                    _mapCubit.selectShop(shop.id),
                                projection: projection,
                                readerAt: state.origin,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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

                Positioned(
                  right: 16,
                  bottom: MediaQuery.sizeOf(context).height * 0.32,
                  child: LocateUserButton(onPressed: _recentreOnReader),
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
