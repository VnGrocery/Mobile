import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/core/location/location_service.dart';
import 'package:vngrocery/data/repositories.dart';
import 'explore_map_state.dart';

class ExploreMapCubit extends Cubit<ExploreMapState> with CloseSafeEmit {
  final AppRepositories _repositories;
  final LocationService _location;

  ExploreMapCubit({
    String? initialShopId,
    AppRepositories? repositories,
    LocationService? location,
  }) : _repositories = repositories ?? AppRepositories.instance,
       _location = location ?? LocationService.instance,
       super(ExploreMapState(selectedShopId: initialShopId));

  /// Finds the reader so the map can open where they are.
  Future<void> locateReader() async {
    final (location, _) = await _location.current();
    if (location == null) return;
    emit(state.copyWith(origin: location.point));
    await load();
  }

  Future<void> load() async {
    emit(state.copyWith(shops: _repositories.shops.all()));
    try {
      final shops = await _repositories.shops.refresh(near: state.origin);
      emit(state.copyWith(shops: shops));
    } catch (_) {}
  }

  void selectShop(String shopId) {
    emit(state.copyWith(selectedShopId: shopId));
  }

  /// Selects the shop closest to the reader.
  ///
  /// Was `locateNearestDemoShop`, which picked `shops.first` — whatever the
  /// server happened to list first — and called it the nearest.
  void selectNearestShop() {
    final nearest = state.nearbyShops.firstOrNull;
    if (nearest == null) return;
    selectShop(nearest.item.id);
  }
}
