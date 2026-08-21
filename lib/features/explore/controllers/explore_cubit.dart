import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/utils/text_search.dart';
import 'package:vngrocery/core/location/location_service.dart';
import 'package:vngrocery/core/location/nearby.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/explore/explore_presenter.dart';
import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> with CloseSafeEmit {
  final AppRepositories _repositories;
  final LocationService _location;

  ExploreCubit({AppRepositories? repositories, LocationService? location})
    : _repositories = repositories ?? AppRepositories.instance,
      _location = location ?? LocationService.instance,
      super(ExploreState.initial());

  /// Finds the reader and, unless they have already picked a chip themselves,
  /// switches to ordering by distance.
  Future<void> locateReader() async {
    final (location, _) = await _location.current();
    if (location == null) return;

    final filter = state.filterChosen
        ? state.selectedFilter
        : ExploreFilters.nearby;
    emit(
      state.copyWith(
        origin: location.point,
        selectedFilter: filter,
        shops: _visibleShops(filter: filter, origin: location.point),
      ),
    );
    // Re-fetch narrowed to the circle now that there is one.
    await load();
  }

  Future<void> load() async {
    emit(state.copyWith(shops: _visibleShops()));
    try {
      await _repositories.shops.refresh(query: state.query, near: state.origin);
      emit(state.copyWith(shops: _visibleShops()));
    } catch (_) {}
  }

  void setQuery(String query) {
    emit(
      state.copyWith(
        query: query,
        clearSelectedShop: true,
        shops: _visibleShops(query: query),
      ),
    );
    load();
  }

  void setFilter(String filter) {
    // The chips used to only record the choice; the list never changed.
    emit(
      state.copyWith(
        selectedFilter: filter,
        filterChosen: true,
        shops: _visibleShops(filter: filter),
      ),
    );
  }

  void selectShop(String shopId) {
    emit(state.copyWith(selectedShopId: shopId));
  }

  List<Shop> _visibleShops({String? query, String? filter, GeoPoint? origin}) {
    final normalizedQuery = (query ?? state.query).trim().toLowerCase();
    final activeFilter = filter ?? state.selectedFilter;

    final shops = _repositories.shops.all().where((shop) {
      if (activeFilter == ExploreFilters.recorded &&
          !(shop.trustSummary?.hasPledges ?? false)) {
        return false;
      }
      if (normalizedQuery.isEmpty) return true;
      // Folded on both sides, so a name typed without tone marks finds the
      // shop that has them.
      return searchContains(shop.name, normalizedQuery) ||
          searchContains(shop.address, normalizedQuery);
    }).toList();

    if (activeFilter == ExploreFilters.nearby) {
      return selectNearby(
        shops,
        origin: origin ?? state.origin,
        locate: (shop) => GeoPoint(shop.latitude, shop.longitude),
      ).items.map((entry) => entry.item).toList();
    }

    switch (activeFilter) {
      case ExploreFilters.topRated:
        shops.sort((a, b) => b.rating.compareTo(a.rating));
      case ExploreFilters.newest:
        // Shops with no creation date sort last rather than jumping to the top.
        shops.sort((a, b) {
          final left = a.createdAt;
          final right = b.createdAt;
          if (left == null && right == null) return 0;
          if (left == null) return 1;
          if (right == null) return -1;
          return right.compareTo(left);
        });
      case ExploreFilters.recorded:
        shops.sort(
          (a, b) => (b.trustSummary?.score ?? 0).compareTo(
            a.trustSummary?.score ?? 0,
          ),
        );
    }
    return shops;
  }
}
