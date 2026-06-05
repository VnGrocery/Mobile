import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'package:vngrocery/data/repositories.dart';
import 'voucher_qr_state.dart';

class VoucherQrCubit extends Cubit<VoucherQrState> {
  final AppDelayService _delayService;
  final AppRepositories _repositories;
  final String userVoucherId;

  VoucherQrCubit({
    required this.userVoucherId,
    AppDelayService delayService = AppDelayService.instance,
    AppRepositories? repositories,
  }) : _delayService = delayService,
       _repositories = repositories ?? AppRepositories.instance,
       super(const VoucherQrState());

  void load() {
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
    await _delayService.wait(AppDelayKind.voucherMarkUsed);
    final used = _repositories.vouchers.useUserVoucher(userVoucherId);
    if (!used) {
      emit(const VoucherQrState());
      return;
    }
    load();
  }
}
