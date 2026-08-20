import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_shop/seller_shop_presenter.dart';
import 'seller_shop_state.dart';

class SellerShopCubit extends Cubit<SellerShopState> with CloseSafeEmit {
  final AppRepositories _repositories;
  String? _shopId;

  SellerShopCubit({required String? shopId, AppRepositories? repositories})
    : _shopId = shopId,
      _repositories = repositories ?? AppRepositories.instance,
      super(const SellerShopState());

  String get effectiveShopId => SellerShopPresenter.effectiveShopId(_shopId);

  Future<void> load() async {
    final shopId = effectiveShopId;
    final cached = _repositories.shops.byIdOrNull(shopId);
    if (cached != null) {
      emit(
        state.copyWith(
          shop: cached,
          dashboard: _repositories.seller.dashboard(shopId),
        ),
      );
    }
    try {
      final mine = await _repositories.shops.fetchMine();
      if (mine == null) return;
      _shopId = mine.id;
      await _repositories.products.refreshShop(mine.id, seller: true);
      emit(
        state.copyWith(
          shop: mine,
          dashboard: _repositories.seller.dashboard(mine.id),
        ),
      );
    } catch (_) {}
  }

  Future<void> save({
    required String name,
    required String description,
    required String address,
  }) async {
    emit(state.copyWith(saving: true));
    final existingId = _repositories.shops.byIdOrNull(effectiveShopId)?.id;
    final shop = await _repositories.shops.saveRemote(
      shopId: existingId,
      name: name.trim(),
      description: description.trim(),
      address: address.trim(),
    );
    _shopId = shop.id;
    emit(
      SellerShopState(
        shop: shop,
        dashboard: _repositories.seller.dashboard(shop.id),
        saving: false,
      ),
    );
  }
}
