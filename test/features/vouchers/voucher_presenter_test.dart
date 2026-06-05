import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/vouchers/voucher_presenter.dart';

void main() {
  group('VoucherPresenter', () {
    test('useUserVoucher preserves data layer bool semantics', () {
      final repos = AppRepositories.instance;
      final created = repos.vouchers.addManualToWallet(
        userEmail: 'presenter-use@vngrocery.com',
        shopId: 's1',
        code: 'presenter-use-01',
        title: 'Voucher kiểm thử presenter',
        note: 'Kiểm tra bool trả về',
        codeFormat: 'QR',
        expiresAt: DateTime(2026, 7),
      );

      expect(created.isUsed, isFalse);
      expect(VoucherPresenter.useUserVoucher('missing-user-voucher'), isFalse);
      expect(repos.vouchers.userVoucherById(created.id).isUsed, isFalse);

      expect(VoucherPresenter.useUserVoucher(created.id), isTrue);
      expect(repos.vouchers.userVoucherById(created.id).isUsed, isTrue);
    });
  });
}
