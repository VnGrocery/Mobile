import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/vouchers/controllers/manual_voucher_cubit.dart';

void main() {
  test('ManualVoucherCubit loads shops and records the code format', () {
    final cubit = ManualVoucherCubit()..load();

    // The cubit no longer invents a code: the screen scans a real one and only
    // the format is recorded here.
    cubit.setCodeFormat('Barcode');

    expect(cubit.state.shops, isNotEmpty);
    expect(cubit.state.shopId, isNotNull);
    expect(cubit.state.codeFormat, 'Barcode');

    cubit.close();
  });

  // A fixed calendar date used to sit here and rot the day it passed: every
  // manual voucher saved without picking an expiry would then fail
  // server-side as already expired.
  test('a fresh cubit defaults to an expiry that has not passed', () {
    final cubit = ManualVoucherCubit()..load();

    expect(cubit.state.expiresAt.isAfter(DateTime.now()), isTrue);

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
