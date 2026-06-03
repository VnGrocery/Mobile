import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories.dart';
import 'explore_map_state.dart';

class ExploreMapCubit extends Cubit<ExploreMapState> {
  final AppRepositories _repositories;

  ExploreMapCubit({
    String? initialShopId,
    AppRepositories? repositories,
  })  : _repositories = repositories ?? AppRepositories.instance,
        super(ExploreMapState(selectedShopId: initialShopId));

  void load() {
    emit(state.copyWith(shops: _repositories.shops.all()));
  }

  void selectShop(String shopId) {
    emit(state.copyWith(selectedShopId: shopId));
  }

  void locateNearestDemoShop() {
    if (state.shops.isEmpty) return;
    selectShop(state.shops.first.id);
  }
}
