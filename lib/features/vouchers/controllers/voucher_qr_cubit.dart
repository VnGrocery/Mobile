import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/repositories.dart';
import 'voucher_qr_state.dart';

class VoucherQrCubit extends Cubit<VoucherQrState> with CloseSafeEmit {
  final AppRepositories _repositories;
  final String userVoucherId;

  VoucherQrCubit({required this.userVoucherId, AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(const VoucherQrState());

  Future<void> load() async {
    _emitCached();
    try {
      await _repositories.vouchers.refreshWallet(
        _repositories.vouchers
                .userVoucherByIdOrNull(userVoucherId)
                ?.userEmail ??
            '',
      );
      _emitCached();
    } catch (_) {}
  }

  void _emitCached() {
    final userVoucher = _repositories.vouchers.userVoucherByIdOrNull(
      userVoucherId,
    );
    final voucher = userVoucher == null
        ? null
        : _repositories.vouchers.byIdOrNull(userVoucher.voucherId);
    final shop = voucher == null
        ? null
        : _repositories.shops.byIdOrNull(voucher.shopId);
    if (userVoucher == null || voucher == null || shop == null) {
      emit(const VoucherQrState());
      return;
    }
    emit(
      VoucherQrState(userVoucher: userVoucher, voucher: voucher, shop: shop),
    );
  }

  Future<void> markUsed() async {
    if (state.disabled || state.confirming) return;
    emit(state.copyWith(confirming: true));
    final used = await _repositories.vouchers.useUserVoucherRemote(
      userVoucherId,
    );
    if (!used) {
      emit(const VoucherQrState());
      return;
    }
    await load();
  }
}
