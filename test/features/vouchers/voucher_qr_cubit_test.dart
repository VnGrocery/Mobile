import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
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

  test('VoucherQrCubit emits disabled empty state for a missing id', () async {
    final cubit = VoucherQrCubit(
      userVoucherId: 'missing-user-voucher',
      markUsedDelay: Duration.zero,
    );

    cubit.load();

    expect(cubit.state.hasData, isFalse);
    expect(cubit.state.disabled, isTrue);

    await cubit.markUsed();

    expect(cubit.state.hasData, isFalse);
    expect(cubit.state.disabled, isTrue);
    expect(cubit.state.confirming, isFalse);

    cubit.close();
  });

  test('VoucherQrCubit emits disabled empty state for dangling voucher id', () {
    final dangling = UserVoucher(
      id: 'uv-dangling-voucher-test',
      userEmail: 'dangling-voucher@vngrocery.com',
      voucherId: 'missing-voucher-for-user-voucher',
    );
    MockDb.instance.userVouchers.insert(0, dangling);
    addTearDown(() => MockDb.instance.userVouchers.remove(dangling));
    final cubit = VoucherQrCubit(
      userVoucherId: dangling.id,
      markUsedDelay: Duration.zero,
    );

    cubit.load();

    expect(cubit.state.hasData, isFalse);
    expect(cubit.state.disabled, isTrue);

    cubit.close();
  });

  test('VoucherQrCubit emits disabled empty state for dangling shop id', () {
    final voucher = Voucher(
      id: 'v-dangling-shop-test',
      code: 'DANGLINGSHOP',
      title: 'Dangling shop',
      shopId: 'missing-shop-for-voucher',
      discountValue: 10,
      isPercent: true,
      minSpend: 0,
      expiresAt: DateTime(2026, 12, 31),
    );
    final userVoucher = UserVoucher(
      id: 'uv-dangling-shop-test',
      userEmail: 'dangling-shop@vngrocery.com',
      voucherId: voucher.id,
    );
    MockDb.instance.vouchers.insert(0, voucher);
    MockDb.instance.userVouchers.insert(0, userVoucher);
    addTearDown(() {
      MockDb.instance.vouchers.remove(voucher);
      MockDb.instance.userVouchers.remove(userVoucher);
    });
    final cubit = VoucherQrCubit(
      userVoucherId: userVoucher.id,
      markUsedDelay: Duration.zero,
    );

    cubit.load();

    expect(cubit.state.hasData, isFalse);
    expect(cubit.state.disabled, isTrue);

    cubit.close();
  });

  test(
      'VoucherQrCubit clears state when voucher disappears before marking used',
      () async {
    final voucher = Voucher(
      id: 'v-removed-before-use-test',
      code: 'REMOVEDBEFOREUSE',
      title: 'Removed before use',
      shopId: 's1',
      discountValue: 10,
      isPercent: true,
      minSpend: 0,
      expiresAt: DateTime(2026, 12, 31),
    );
    final userVoucher = UserVoucher(
      id: 'uv-removed-before-use-test',
      userEmail: 'removed-before-use@vngrocery.com',
      voucherId: voucher.id,
    );
    MockDb.instance.vouchers.insert(0, voucher);
    MockDb.instance.userVouchers.insert(0, userVoucher);
    addTearDown(() {
      MockDb.instance.vouchers.remove(voucher);
      MockDb.instance.userVouchers.remove(userVoucher);
    });
    final cubit = VoucherQrCubit(
      userVoucherId: userVoucher.id,
      markUsedDelay: Duration.zero,
    )..load();
    MockDb.instance.userVouchers.remove(userVoucher);

    await cubit.markUsed();

    expect(cubit.state.hasData, isFalse);
    expect(cubit.state.disabled, isTrue);
    expect(cubit.state.confirming, isFalse);

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
