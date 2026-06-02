import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/repositories.dart';

void main() {
  group('AppRepositories mock data layer', () {
    test('loads shops and products from mock JSON', () {
      final repos = AppRepositories.instance;

      expect(repos.shops.all(), isNotEmpty);
      expect(repos.products.all(), isNotEmpty);
      expect(repos.products.byId('p1').name, 'Thịt bò thăn ngoại Úc');
    });

    test('checks valid shop voucher against order value', () {
      final result = AppRepositories.instance.vouchers.check(
        code: 'FRESH20',
        shopId: 's1',
        orderValue: 250000,
      );

      expect(result.valid, isTrue);
      expect(result.discountAmount, 50000);
      expect(result.finalPrice, 200000);
    });

    test('manual voucher is saved to user wallet', () {
      final repos = AppRepositories.instance;
      final created = repos.vouchers.addManualToWallet(
        userEmail: 'test@vngrocery.com',
        shopId: 's1',
        code: 'manual-01',
        title: 'Voucher nhập tay',
        note: 'Khách tự nhập',
        codeFormat: 'QR',
        expiresAt: DateTime(2026, 7),
      );

      final wallet = repos.vouchers.wallet('test@vngrocery.com');

      expect(wallet.map((item) => item.id), contains(created.id));
      expect(repos.vouchers.byId(created.voucherId).isManual, isTrue);
    });
  });
}
