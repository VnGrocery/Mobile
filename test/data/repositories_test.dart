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

    test('missing ids fail fast instead of returning first records', () {
      final repos = AppRepositories.instance;
      final firstShop = repos.shops.all().first;
      final firstProduct = repos.products.all().first;
      final firstVoucher = repos.vouchers.byId('v1');
      final firstUserVoucher =
          repos.vouchers.wallet('demo@vngrocery.com').first;

      expect(repos.shops.byIdOrNull('missing-shop'), isNull);
      expect(repos.products.byIdOrNull('missing-product'), isNull);
      expect(repos.vouchers.byIdOrNull('missing-voucher'), isNull);
      expect(
          repos.vouchers.userVoucherByIdOrNull('missing-user-voucher'), isNull);

      expect(
        () => repos.shops.byId('missing-shop'),
        throwsA(isA<StateError>()),
      );
      expect(
        () => repos.products.byId('missing-product'),
        throwsA(isA<StateError>()),
      );
      expect(
        () => repos.vouchers.byId('missing-voucher'),
        throwsA(isA<StateError>()),
      );
      expect(
        () => repos.vouchers.userVoucherById('missing-user-voucher'),
        throwsA(isA<StateError>()),
      );

      expect(repos.shops.all().first, same(firstShop));
      expect(repos.products.all().first, same(firstProduct));
      expect(repos.vouchers.byId('v1'), same(firstVoucher));
      expect(repos.vouchers.wallet('demo@vngrocery.com').first,
          same(firstUserVoucher));
    });

    test('using missing user voucher does not mutate wallet items', () {
      final repos = AppRepositories.instance;
      final created = repos.vouchers.addManualToWallet(
        userEmail: 'missing-use@vngrocery.com',
        shopId: 's1',
        code: 'missing-use-01',
        title: 'Voucher kiểm thử',
        note: 'Không được đổi trạng thái khi id thiếu',
        codeFormat: 'QR',
        expiresAt: DateTime(2026, 7),
      );

      expect(created.isUsed, isFalse);
      expect(repos.vouchers.useUserVoucher('missing-user-voucher'), isFalse);
      expect(repos.vouchers.userVoucherById(created.id).isUsed, isFalse);

      expect(repos.vouchers.useUserVoucher(created.id), isTrue);
      expect(repos.vouchers.userVoucherById(created.id).isUsed, isTrue);
    });
  });
}
