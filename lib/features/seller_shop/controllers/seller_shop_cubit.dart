import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories.dart';
import '../seller_shop_presenter.dart';
import 'seller_shop_state.dart';

class SellerShopCubit extends Cubit<SellerShopState> {
  final AppRepositories _repositories;
  String? _shopId;

  SellerShopCubit({
    required String? shopId,
    AppRepositories? repositories,
  })  : _shopId = shopId,
        _repositories = repositories ?? AppRepositories.instance,
        super(const SellerShopState());

  String get effectiveShopId => SellerShopPresenter.effectiveShopId(_shopId);

  void load() {
    final shopId = effectiveShopId;
    emit(
      state.copyWith(
        shop: _repositories.shops.byId(shopId),
        dashboard: _repositories.seller.dashboard(shopId),
      ),
    );
  }

  Future<void> save({
    required String name,
    required String description,
    required String address,
  }) async {
    emit(state.copyWith(saving: true));
    final shop = _repositories.shops.save(
      shopId: effectiveShopId,
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
