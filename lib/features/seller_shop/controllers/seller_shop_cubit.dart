import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/repositories.dart';
import 'seller_shop_state.dart';

class SellerShopCubit extends Cubit<SellerShopState> with CloseSafeEmit {
  final AppRepositories _repositories;
  String? _shopId;

  SellerShopCubit({required String? shopId, AppRepositories? repositories})
    : _shopId = shopId,
      _repositories = repositories ?? AppRepositories.instance,
      super(const SellerShopState());

  /// The shop being edited, or null while this account still has none.
  String? get shopId => _shopId;

  Future<void> load() async {
    final cachedId = _shopId;
    final cached = cachedId == null
        ? null
        : _repositories.shops.byIdOrNull(cachedId);
    if (cached != null) {
      emit(
        state.copyWith(
          shop: cached,
          dashboard: _repositories.seller.dashboard(cached.id),
          status: SellerShopStatus.ready,
        ),
      );
    }
    try {
      final mine = await _repositories.shops.fetchMine();
      if (mine == null) {
        // No shop yet. This used to return without emitting, leaving the
        // screen spinning for ever; the form is now offered empty so the
        // seller can create one.
        emit(state.copyWith(status: SellerShopStatus.noShop));
        return;
      }
      _shopId = mine.id;
      await _repositories.products.refreshShop(mine.id, seller: true);
      emit(
        state.copyWith(
          shop: mine,
          dashboard: _repositories.seller.dashboard(mine.id),
          status: SellerShopStatus.ready,
        ),
      );
    } catch (_) {
      // Keep whatever was cached - stale details beat an empty form that would
      // overwrite them on save - but say the refresh failed instead of
      // pretending to still be loading.
      emit(
        state.copyWith(
          status: state.shop == null
              ? SellerShopStatus.failed
              : SellerShopStatus.ready,
        ),
      );
    }
  }

  Future<void> save({
    required String name,
    required String description,
    required String address,
    String changeReason = '',
    bool commentModeration = false,
  }) async {
    emit(state.copyWith(saving: true));
    try {
      final shop = await _repositories.shops.saveRemote(
        shopId: _shopId,
        name: name.trim(),
        description: description.trim(),
        address: address.trim(),
        changeReason: changeReason.trim(),
        commentModeration: commentModeration,
      );
      _shopId = shop.id;
      emit(
        SellerShopState(
          shop: shop,
          dashboard: _repositories.seller.dashboard(shop.id),
          status: SellerShopStatus.ready,
        ),
      );
    } catch (_) {
      // The screen reports the failure; without this the button stayed stuck
      // in its spinner and the seller had no idea the save had not landed.
      emit(state.copyWith(saving: false));
      rethrow;
    }
  }
}
