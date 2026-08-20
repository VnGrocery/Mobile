import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/explore/explore_presenter.dart';
import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final AppRepositories _repositories;

  ExploreCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(ExploreState.initial());

  Future<void> load() async {
    emit(state.copyWith(shops: _visibleShops()));
    try {
      await _repositories.shops.refresh(query: state.query);
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
        shops: _visibleShops(filter: filter),
      ),
    );
  }

  void selectShop(String shopId) {
    emit(state.copyWith(selectedShopId: shopId));
  }

  List<Shop> _visibleShops({String? query, String? filter}) {
    final normalizedQuery = (query ?? state.query).trim().toLowerCase();
    final activeFilter = filter ?? state.selectedFilter;

    final shops = _repositories.shops.all().where((shop) {
      if (activeFilter == ExploreFilters.recorded &&
          !(shop.trustSummary?.hasPledges ?? false)) {
        return false;
      }
      if (normalizedQuery.isEmpty) return true;
      return shop.name.toLowerCase().contains(normalizedQuery) ||
          shop.address.toLowerCase().contains(normalizedQuery);
    }).toList();

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
