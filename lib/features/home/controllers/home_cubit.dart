import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/core/location/location_service.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/home/home_presenter.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> with CloseSafeEmit {
  final AppRepositories _repositories;
  final LocationService _location;

  HomeCubit({AppRepositories? repositories, LocationService? location})
    : _repositories = repositories ?? AppRepositories.instance,
      _location = location ?? LocationService.instance,
      super(const HomeState());

  /// Finds the reader so the lists can be ordered by how far away things are.
  ///
  /// Kept apart from [load] because it can prompt for a permission: the
  /// catalogue must still arrive if the reader says no, and refreshing the
  /// catalogue must not re-ask.
  Future<void> locateReader() async {
    final (location, denial) = await _location.current();
    emit(state.withLocation(location, denial));
    if (location != null) {
      // Now that there is a point to search around, ask the server for just
      // the shops near it rather than keeping the whole catalogue.
      await load();
    }
    await loadRecommendations();
  }

  /// Loads suggestions for this reader.
  ///
  /// Separate from [load] because it needs a signed-in account and the
  /// catalogue does not: the home page must still render for a reader whose
  /// suggestions could not be fetched.
  Future<void> loadRecommendations() async {
    final remote = _repositories.products.remote;
    if (remote == null) return;
    try {
      final suggestions = await remote.recommendations(near: state.origin);
      emit(state.withRecommendations(suggestions));
    } catch (_) {
      // The section stays hidden rather than showing an empty list, which
      // would read as "we have nothing for you".
    }
  }

  Future<void> load() async {
    _emitCached(HomeStatus.loading);
    try {
      final shops = await _repositories.shops.refresh(near: state.origin);
      for (final shop in shops) {
        await _repositories.products.refreshShop(shop.id);
      }
      _emitCached(HomeStatus.ready);
      await loadRecommendations();
    } catch (_) {
      // Whatever is cached still gets shown; the status is what lets the tab
      // say the refresh failed instead of pretending there is nothing to sell.
      _emitCached(HomeStatus.failed);
    }
  }

  void _emitCached(HomeStatus status) {
    final shops = _repositories.shops.all();
    final products = _repositories.products.all();
    // A product whose shop is not in the cache cannot be shown: the card names
    // the shop selling it. Skipping is right rather than throwing, because this
    // runs on the failure path too, where the shop list may be mid-refresh.
    final pledgeItems = <HomePledgeItem>[];
    for (final product in products) {
      final shop = _repositories.shops.byIdOrNull(product.shopId);
      if (shop == null) continue;
      pledgeItems.add(HomePledgeItem(product: product, shop: shop));
    }

    emit(
      HomeState(
        status: status,
        shops: shops,
        products: products,
        pledgeItems: pledgeItems,
        // A catalogue refresh must not throw away a location already found,
        // nor the suggestions loaded alongside it.
        location: state.location,
        locationDenial: state.locationDenial,
        recommendations: state.recommendations,
      ),
    );
  }
}
