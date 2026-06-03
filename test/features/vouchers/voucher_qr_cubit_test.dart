import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/vouchers/controllers/voucher_qr_cubit.dart';

void main() {
  test('VoucherQrCubit loads voucher QR data', () {
    final userVoucher = AppRepositories.instance.vouchers
        .wallet('demo@vngrocery.com')
        .firstWhere((item) => !item.isUsed);
    final cubit = VoucherQrCubit(
      userVoucherId: userVoucher.id,
      markUsedDelay: Duration.zero,
    );

    cubit.load();

    expect(cubit.state.hasData, isTrue);
    expect(cubit.state.userVoucher?.id, userVoucher.id);
    expect(cubit.state.disabled, isFalse);

    cubit.close();
  });

  test('VoucherQrCubit marks voucher as used', () async {
    final userVoucher = AppRepositories.instance.vouchers
        .wallet('demo@vngrocery.com')
        .firstWhere((item) => !item.isUsed);
    final cubit = VoucherQrCubit(
      userVoucherId: userVoucher.id,
      markUsedDelay: Duration.zero,
    )..load();

    await cubit.markUsed();

    expect(cubit.state.userVoucher?.isUsed, isTrue);
    expect(cubit.state.disabled, isTrue);
    expect(cubit.state.confirming, isFalse);

    cubit.close();
  });
}
