import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';

class ShopVouchersState {
  final List<Voucher> offers;

  /// Ids the reader already holds. The list endpoint is public and says
  /// nothing about who is asking, so the wallet is what turns "Nhận" into
  /// "Đã nhận" rather than a second claim that would do nothing.
  final Set<String> claimed;

  final bool loading;

  /// Could not be read. Kept apart from "this shop runs no offers", which is
  /// a fact about the shop rather than about the connection.
  final bool failed;

  /// The offer a claim is in flight for, so only its own button spins.
  final String? claiming;

  const ShopVouchersState({
    this.offers = const [],
    this.claimed = const {},
    this.loading = false,
    this.failed = false,
    this.claiming,
  });

  bool get isEmpty => offers.isEmpty;

  ShopVouchersState copyWith({
    List<Voucher>? offers,
    Set<String>? claimed,
    bool? loading,
    bool? failed,
    String? claiming,
    bool clearClaiming = false,
  }) {
    return ShopVouchersState(
      offers: offers ?? this.offers,
      claimed: claimed ?? this.claimed,
      loading: loading ?? this.loading,
      failed: failed ?? this.failed,
      claiming: clearClaiming ? null : (claiming ?? this.claiming),
    );
  }
}

/// The offers one shop is running, and which of them the reader holds.
class ShopVouchersCubit extends Cubit<ShopVouchersState> with CloseSafeEmit {
  final AppRepositories _repositories;
  final String shopId;

  ShopVouchersCubit({required this.shopId, AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(const ShopVouchersState());

  RemoteDataSource? get _remote => _repositories.products.remote;

  Future<void> load() async {
    final remote = _remote;
    if (remote == null) {
      emit(state.copyWith(loading: false, failed: true));
      return;
    }
    emit(state.copyWith(loading: true, failed: false));
    try {
      // Together: an offer list without the wallet beside it would invite the
      // reader to claim what they already have.
      final results = await Future.wait([
        remote.shopVouchers(shopId),
        remote.wallet(),
      ]);
      final offers = results[0] as List<Voucher>;
      final wallet =
          results[1] as List<({UserVoucher userVoucher, Voucher voucher})>;
      emit(
        state.copyWith(
          offers: offers.where((offer) => offer.isActive).toList(),
          claimed: wallet.map((item) => item.voucher.id).toSet(),
          loading: false,
          failed: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loading: false, failed: true));
    }
  }

  /// Takes one claim. Rethrows so the screen can say what went wrong; the
  /// server refuses an offer that has run out rather than letting the app
  /// guess from a stale count.
  Future<void> claim(Voucher offer) async {
    final remote = _remote;
    if (remote == null) throw StateError('no remote data source');
    emit(state.copyWith(claiming: offer.id));
    try {
      await remote.saveVoucher(offer.id);
    } catch (_) {
      emit(state.copyWith(clearClaiming: true));
      rethrow;
    }
    // Reload rather than decrement locally: how many are left is the server's
    // answer, and someone else may have taken one in the meantime.
    await load();
    emit(state.copyWith(clearClaiming: true));
  }
}
