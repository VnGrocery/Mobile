import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/repositories.dart';
import 'seller_dashboard_state.dart';

class SellerDashboardCubit extends Cubit<SellerDashboardState>
    with CloseSafeEmit {
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
        SellerDashboardState(
          dashboard: _repositories.seller.dashboard(shopId),
          status: SellerDashboardStatus.ready,
        ),
      );
    }
    try {
      final shop = cached ?? await _repositories.shops.fetchMine();
      if (shop == null) {
        // Signed in, but this account does not keep a shop. Saying so is the
        // whole point: returning without emitting left the tab on a spinner
        // that could never stop, because nothing was ever coming.
        emit(const SellerDashboardState(status: SellerDashboardStatus.noShop));
        return;
      }
      await _repositories.products.refreshShop(shop.id, seller: true);
      for (final product in _repositories.products.all(shopId: shop.id)) {
        await _repositories.pledges.refresh(shop.id, product.id);
      }
      emit(
        SellerDashboardState(
          dashboard: _repositories.seller.dashboard(shop.id),
          status: SellerDashboardStatus.ready,
        ),
      );
    } catch (_) {
      // Swallowing this used to be indistinguishable from still loading. The
      // figures already on screen are kept - stale numbers beat none - and the
      // tab now says the refresh failed and offers to try again.
      emit(
        SellerDashboardState(
          dashboard: state.dashboard,
          status: SellerDashboardStatus.failed,
        ),
      );
    }
  }
}
