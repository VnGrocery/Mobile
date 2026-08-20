import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/repositories.dart';
import 'explore_map_state.dart';

class ExploreMapCubit extends Cubit<ExploreMapState> with CloseSafeEmit {
  final AppRepositories _repositories;

  ExploreMapCubit({String? initialShopId, AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(ExploreMapState(selectedShopId: initialShopId));

  Future<void> load() async {
    emit(state.copyWith(shops: _repositories.shops.all()));
    try {
      final shops = await _repositories.shops.refresh();
      emit(state.copyWith(shops: shops));
    } catch (_) {}
  }

  void selectShop(String shopId) {
    emit(state.copyWith(selectedShopId: shopId));
  }

  void locateNearestDemoShop() {
    if (state.shops.isEmpty) return;
    selectShop(state.shops.first.id);
  }
}
