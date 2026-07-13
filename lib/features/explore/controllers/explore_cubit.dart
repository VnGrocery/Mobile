import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final AppRepositories _repositories;

  ExploreCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(ExploreState.initial());

  Future<void> load() async {
    emit(state.copyWith(shops: _filteredShops(state.query)));
    try {
      await _repositories.shops.refresh(query: state.query);
      emit(state.copyWith(shops: _filteredShops(state.query)));
    } catch (_) {}
  }

  void setQuery(String query) {
    emit(
      state.copyWith(
        query: query,
        clearSelectedShop: true,
        shops: _filteredShops(query),
      ),
    );
    load();
  }

  void setFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter));
  }

  void selectShop(String shopId) {
    emit(state.copyWith(selectedShopId: shopId));
  }

  List<Shop> _filteredShops(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    return _repositories.shops.all().where((shop) {
      if (normalizedQuery.isEmpty) return true;
      return shop.name.toLowerCase().contains(normalizedQuery) ||
          shop.address.toLowerCase().contains(normalizedQuery);
    }).toList();
  }
}
