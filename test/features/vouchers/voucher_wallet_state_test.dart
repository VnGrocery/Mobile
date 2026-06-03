import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/vouchers/controllers/voucher_wallet_state.dart';

void main() {
  test('VoucherWalletState hides used vouchers by default', () {
    final state = VoucherWalletState(
      wallet: [
        UserVoucher(id: 'uv-1', userEmail: 'demo@test.com', voucherId: 'v-1'),
        UserVoucher(
          id: 'uv-2',
          userEmail: 'demo@test.com',
          voucherId: 'v-2',
          used: true,
        ),
      ],
    );

    expect(state.usableCount, 1);
    expect(state.visibleWallet.map((item) => item.id), ['uv-1']);
  });

  test('VoucherWalletState shows used vouchers when enabled', () {
    final state = VoucherWalletState(
      showUsed: true,
      wallet: [
        UserVoucher(id: 'uv-1', userEmail: 'demo@test.com', voucherId: 'v-1'),
        UserVoucher(
          id: 'uv-2',
          userEmail: 'demo@test.com',
          voucherId: 'v-2',
          used: true,
        ),
      ],
    );

    expect(state.visibleWallet.length, 2);
  });
}
