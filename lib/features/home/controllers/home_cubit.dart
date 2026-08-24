import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/core/location/location_service.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
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
    await loadOffers();
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
      // Deep enough to fill the ranked grid, not just the spotlight row: the
      // grid is the catalogue, ordered by the same signals.
      final suggestions = await remote.recommendations(
        near: state.origin,
        limit: HomeState.rankedLimit,
      );
      emit(state.withRecommendations(suggestions));
    } catch (_) {
      // The section stays hidden rather than showing an empty list, which
      // would read as "we have nothing for you".
    }
  }

  /// Loads the offers behind the advert slot.
  ///
  /// Kept apart from the catalogue for the same reason as the suggestions: a
  /// home page with no offers is still a home page.
  Future<void> loadOffers() async {
    final remote = _repositories.products.remote;
    if (remote == null) return;
    try {
      // The wallet comes with them: an advert that invites a claim the reader
      // already made is worse than no advert.
      final results = await Future.wait([
        remote.featuredVouchers(),
        remote.wallet(),
      ]);
      final offers = results[0] as List<FeaturedVoucher>;
      final wallet =
          results[1] as List<({UserVoucher userVoucher, Voucher voucher})>;
      emit(
        state.withOffers(
          offers,
          claimed: wallet.map((item) => item.voucher.id).toSet(),
        ),
      );
    } catch (_) {
      // The slot hides itself rather than advertising an error.
    }
  }

  /// Takes one of the advertised offers. Rethrows so the tab can tell a shop
  /// that ran out apart from a connection that dropped.
  Future<void> claimOffer(FeaturedVoucher offer) async {
    final remote = _repositories.products.remote;
    if (remote == null) throw StateError('no remote data source');
    emit(state.withOffers(state.offers, claiming: offer.voucher.id));
    try {
      await remote.saveVoucher(offer.voucher.id);
    } catch (_) {
      emit(state.withOffers(state.offers, clearClaiming: true));
      rethrow;
    }
    // Reloaded rather than counted down here: how many are left is the
    // server's answer, and the slot drops an offer that has just run out.
    await loadOffers();
    emit(state.withOffers(state.offers, clearClaiming: true));
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
      await loadOffers();
    } catch (_) {
      // Whatever is cached still gets shown; the status is what lets the tab
      // say the refresh failed instead of pretending there is nothing to sell.
      _emitCached(HomeStatus.failed);
    }
  }

  void _emitCached(HomeStatus status) {
    final shops = _repositories.shops.all();
    final products = _repositories.products.all();
    emit(
      HomeState(
        status: status,
        shops: shops,
        products: products,
        // A catalogue refresh must not throw away a location already found,
        // nor the suggestions loaded alongside it.
        location: state.location,
        locationDenial: state.locationDenial,
        recommendations: state.recommendations,
        offers: state.offers,
      ),
    );
  }
}
