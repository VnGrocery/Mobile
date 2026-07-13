import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/repositories.dart';
import 'seller_dashboard_state.dart';

class SellerDashboardCubit extends Cubit<SellerDashboardState> {
  final AppRepositories _repositories;

  SellerDashboardCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(const SellerDashboardState());

  Future<void> load(String? shopId) async {
    final cached = shopId == null
        ? null
        : _repositories.shops.byIdOrNull(shopId);
    if (cached != null) {
      emit(
        SellerDashboardState(dashboard: _repositories.seller.dashboard(shopId)),
      );
    }
    try {
      final shop = cached ?? await _repositories.shops.fetchMine();
      if (shop == null) return;
      await _repositories.products.refreshShop(shop.id, seller: true);
      for (final product in _repositories.products.all(shopId: shop.id)) {
        await _repositories.pledges.refresh(shop.id, product.id);
      }
      emit(
        SellerDashboardState(
          dashboard: _repositories.seller.dashboard(shop.id),
        ),
      );
    } catch (_) {}
  }
}
