import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/buyer_check/controllers/buyer_check_cubit.dart';

void main() {
  test('BuyerCheckCubit loads demo result with product and shop', () {
    final cubit = BuyerCheckCubit();

    cubit.loadDemoResult();

    expect(cubit.state.hasData, isTrue);
    expect(cubit.state.product?.shopId, cubit.state.shop?.id);

    cubit.close();
  });

  test('BuyerCheckCubit checks voucher against current product', () {
    final cubit = BuyerCheckCubit()..loadDemoResult();

    cubit.checkVoucher('FRESH20');

    expect(cubit.state.voucherResult, isNotNull);

    cubit.close();
  });
}
