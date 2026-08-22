import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'voucher_wallet_state.dart';

class VoucherWalletCubit extends Cubit<VoucherWalletState> with CloseSafeEmit {
  final AppRepositories _repositories;
  final String _userEmail;

  VoucherWalletCubit({required String userEmail, AppRepositories? repositories})
    : _userEmail = userEmail,
      _repositories = repositories ?? AppRepositories.instance,
      super(const VoucherWalletState());

  Future<void> load() async {
    _emitCached();
    try {
      await _repositories.vouchers.refreshWallet(_userEmail);
      _emitCached();
    } catch (_) {}
  }

  void _emitCached() {
    final wallet = _repositories.vouchers.wallet(_userEmail);
    final vouchersById = _resolveVouchers(wallet);
    emit(
      state.copyWith(
        wallet: wallet,
        vouchersById: vouchersById,
        shopsById: _resolveShops(vouchersById.values),
      ),
    );
  }

  void setShowUsed(bool value) {
    emit(state.copyWith(showUsed: value));
  }

  // Both maps skip what the cache has no answer for instead of throwing: the
  // wallet outlives the catalogue, so a saved voucher can point at a shop that
  // has since fallen outside the search radius. The state exposes these through
  // `voucherOrNull`/`shopOrNull`, so a missing entry degrades one row rather
  // than taking down the whole wallet.
  Map<String, Voucher> _resolveVouchers(List<UserVoucher> wallet) {
    final resolved = <String, Voucher>{};
    for (final item in wallet) {
      final voucher = _repositories.vouchers.byIdOrNull(item.voucherId);
      if (voucher != null) resolved[item.voucherId] = voucher;
    }
    return resolved;
  }

  Map<String, Shop> _resolveShops(Iterable<Voucher> vouchers) {
    final resolved = <String, Shop>{};
    for (final voucher in vouchers) {
      final shop = _repositories.shops.byIdOrNull(voucher.shopId);
      if (shop != null) resolved[voucher.shopId] = shop;
    }
    return resolved;
  }
}
