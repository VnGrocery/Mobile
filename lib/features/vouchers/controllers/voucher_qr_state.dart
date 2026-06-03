import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/vouchers/voucher_presenter.dart';

class VoucherQrState {
  final UserVoucher? userVoucher;
  final Voucher? voucher;
  final Shop? shop;
  final bool confirming;

  const VoucherQrState({
    this.userVoucher,
    this.voucher,
    this.shop,
    this.confirming = false,
  });

  bool get hasData => userVoucher != null && voucher != null && shop != null;

  bool get disabled {
    final loadedUserVoucher = userVoucher;
    final loadedVoucher = voucher;
    if (loadedUserVoucher == null || loadedVoucher == null) return true;
    return VoucherPresenter.isDisabled(loadedUserVoucher, loadedVoucher);
  }

  VoucherQrState copyWith({
    UserVoucher? userVoucher,
    Voucher? voucher,
    Shop? shop,
    bool? confirming,
  }) {
    return VoucherQrState(
      userVoucher: userVoucher ?? this.userVoucher,
      voucher: voucher ?? this.voucher,
      shop: shop ?? this.shop,
      confirming: confirming ?? this.confirming,
    );
  }
}
