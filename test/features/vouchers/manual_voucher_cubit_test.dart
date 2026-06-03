import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/vouchers/controllers/manual_voucher_cubit.dart';

void main() {
  test('ManualVoucherCubit loads shops and scans demo code', () {
    final cubit = ManualVoucherCubit()..load();

    final code = cubit.scanDemo('Barcode');

    expect(cubit.state.shops, isNotEmpty);
    expect(cubit.state.shopId, isNotNull);
    expect(cubit.state.codeFormat, 'Barcode');
    expect(code, 'BARCODE-8938505970012');

    cubit.close();
  });

  test('ManualVoucherCubit updates expiry and saves manual voucher', () {
    final cubit = ManualVoucherCubit()..load();
    cubit.setExpiry(DateTime(2027, 1, 2));

    final saved = cubit.save(
      userEmail: 'demo@test.com',
      code: 'MANUAL20',
      title: 'Manual discount',
      note: 'Customer note',
    );

    expect(cubit.state.expiresAt, DateTime(2027, 1, 2, 23, 59));
    expect(saved, isNotNull);
    expect(cubit.state.saved, isTrue);

    cubit.close();
  });
}
