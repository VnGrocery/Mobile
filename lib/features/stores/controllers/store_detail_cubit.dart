import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'store_detail_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailState> with CloseSafeEmit {
  final AppRepositories _repositories;

  StoreDetailCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(const StoreDetailState());

  Future<void> load(String shopId) async {
    _emitCached(shopId);
    try {
      await Future.wait([
        _repositories.shops.fetch(shopId),
        _repositories.products.refreshShop(shopId),
        _repositories.reviews.refresh(shopId),
      ]);
      _emitCached(shopId);
    } catch (_) {}
  }

  void _emitCached(String shopId) {
    final shop = _repositories.shops.byIdOrNull(shopId);
    if (shop == null) return;
    emit(
      StoreDetailState(
        shop: shop,
        products: _repositories.products.all(shopId: shopId),
        reviews: _repositories.reviews.ofShop(shopId),
      ),
    );
  }

  String shareText(Shop shop, String summary) {
    return '${shop.name}\n${shop.address}\n$summary';
  }
}
