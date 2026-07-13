import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'voucher_wallet_state.dart';

class VoucherWalletCubit extends Cubit<VoucherWalletState> {
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

  Map<String, Voucher> _resolveVouchers(List<UserVoucher> wallet) {
    return {
      for (final item in wallet)
        item.voucherId: _repositories.vouchers.byId(item.voucherId),
    };
  }

  Map<String, Shop> _resolveShops(Iterable<Voucher> vouchers) {
    return {
      for (final voucher in vouchers)
        voucher.shopId: _repositories.shops.byId(voucher.shopId),
    };
  }
}
