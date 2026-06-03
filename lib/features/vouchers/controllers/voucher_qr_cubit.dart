import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories.dart';
import 'voucher_qr_state.dart';

class VoucherQrCubit extends Cubit<VoucherQrState> {
  final AppRepositories _repositories;
  final String userVoucherId;
  final Duration markUsedDelay;

  VoucherQrCubit({
    required this.userVoucherId,
    this.markUsedDelay = const Duration(milliseconds: 450),
    AppRepositories? repositories,
  })  : _repositories = repositories ?? AppRepositories.instance,
        super(const VoucherQrState());

  void load() {
    final userVoucher = _repositories.vouchers.userVoucherById(userVoucherId);
    final voucher = _repositories.vouchers.byId(userVoucher.voucherId);
    final shop = _repositories.shops.byId(voucher.shopId);
    emit(
        VoucherQrState(userVoucher: userVoucher, voucher: voucher, shop: shop));
  }

  Future<void> markUsed() async {
    if (state.disabled || state.confirming) return;
    emit(state.copyWith(confirming: true));
    await Future<void>.delayed(markUsedDelay);
    _repositories.vouchers.useUserVoucher(userVoucherId);
    load();
  }
}
