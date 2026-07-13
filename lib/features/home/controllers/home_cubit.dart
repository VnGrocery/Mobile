import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/home/home_presenter.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppRepositories _repositories;

  HomeCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(const HomeState());

  Future<void> load() async {
    _emitCached();
    try {
      final shops = await _repositories.shops.refresh();
      for (final shop in shops) {
        await _repositories.products.refreshShop(shop.id);
      }
      _emitCached();
    } catch (_) {}
  }

  void _emitCached() {
    final shops = _repositories.shops.all();
    final products = _repositories.products.all();
    final pledgeItems = products
        .map(
          (product) => HomePledgeItem(
            product: product,
            shop: _repositories.shops.byId(product.shopId),
          ),
        )
        .toList();

    emit(HomeState(shops: shops, products: products, pledgeItems: pledgeItems));
  }
}
