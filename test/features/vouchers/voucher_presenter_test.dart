import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/vouchers/voucher_presenter.dart';

void main() {
  group('VoucherPresenter', () {
    test('labels and payload reflect voucher type and state', () {
      final manual = Voucher(
        id: 'v-manual',
        code: 'QR-DEMO',
        title: 'Manual',
        shopId: 's1',
        discountValue: 0,
        isPercent: false,
        minSpend: 0,
        expiresAt: DateTime(2026, 12, 31),
        manual: true,
        codeFormat: 'QR',
      );
      final percent = Voucher(
        id: 'v-percent',
        code: 'SALE20',
        title: 'Percent',
        shopId: 's1',
        discountValue: 20,
        isPercent: true,
        minSpend: 100000,
        expiresAt: DateTime(2026, 12, 31),
      );
      final userVoucher = UserVoucher(
        id: 'uv-1',
        userEmail: 'demo@vngrocery.com',
        voucherId: 'v-percent',
      );
      const shop = Shop(
        id: 's1',
        name: 'Demo shop',
        address: '123 Demo',
        rating: 4.8,
        reviewCount: 120,
        description: 'desc',
      );

      expect(VoucherPresenter.discountLabel(manual), 'QR');
      expect(VoucherPresenter.spendLabel(manual), 'Thông tin tự nhập');
      expect(VoucherPresenter.ruleDiscountLabel(manual), 'Theo thông tin bạn tự nhập');
      expect(VoucherPresenter.discountLabel(percent), 'Giảm 20%');
      expect(VoucherPresenter.statusLabel(userVoucher, percent), 'Có thể dùng');
      expect(VoucherPresenter.detailStatus(userVoucher, percent), 'Sẵn sàng sử dụng');
      expect(
        VoucherPresenter.qrPayload(
          userVoucher: userVoucher,
          voucher: percent,
          shop: shop,
        ),
        'VNGROCERY:uv-1:SALE20:s1',
      );
      expect(
        VoucherPresenter.qrPayload(
          userVoucher: userVoucher,
          voucher: manual,
          shop: shop,
        ),
        'QR-DEMO',
      );
    });

    test('expiry and disabled state follow voucher status', () {
      final expiredVoucher = Voucher(
        id: 'v-expired',
        code: 'OLD',
        title: 'Expired',
        shopId: 's1',
        discountValue: 10,
        isPercent: true,
        minSpend: 0,
        expiresAt: DateTime(2026, 1, 1),
      );
      final usedVoucher = UserVoucher(
        id: 'uv-used',
        userEmail: 'demo@vngrocery.com',
        voucherId: 'v-expired',
      )..used = true;

      expect(
        VoucherPresenter.isExpired(
          expiredVoucher,
          now: DateTime(2026, 2, 1),
        ),
        isTrue,
      );
      expect(VoucherPresenter.isDisabled(usedVoucher, expiredVoucher), isTrue);
      expect(VoucherPresenter.statusLabel(usedVoucher, expiredVoucher), 'Đã dùng');
      expect(VoucherPresenter.detailStatus(usedVoucher, expiredVoucher), 'Đã dùng');
      expect(VoucherPresenter.expiryLabel(expiredVoucher), 'HSD 1/1/2026');
    });

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
