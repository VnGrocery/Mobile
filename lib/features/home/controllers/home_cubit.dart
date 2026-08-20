import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/home/home_presenter.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> with CloseSafeEmit {
  final AppRepositories _repositories;

  HomeCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(const HomeState());

  Future<void> load() async {
    _emitCached(HomeStatus.loading);
    try {
      final shops = await _repositories.shops.refresh();
      for (final shop in shops) {
        await _repositories.products.refreshShop(shop.id);
      }
      _emitCached(HomeStatus.ready);
    } catch (_) {
      // Whatever is cached still gets shown; the status is what lets the tab
      // say the refresh failed instead of pretending there is nothing to sell.
      _emitCached(HomeStatus.failed);
    }
  }

  void _emitCached(HomeStatus status) {
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

    emit(
      HomeState(
        status: status,
        shops: shops,
        products: products,
        pledgeItems: pledgeItems,
      ),
    );
  }
}
