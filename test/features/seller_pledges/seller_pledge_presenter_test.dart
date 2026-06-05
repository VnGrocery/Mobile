import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/seller_pledges/seller_pledge_presenter.dart';

void main() {
  group('SellerPledgePresenter', () {
    test('titleForStep maps pledge steps', () {
      expect(SellerPledgePresenter.titleForStep(1), 'Bước 1: Chụp ảnh hàng');
      expect(SellerPledgePresenter.titleForStep(2), 'Bước 2: Chấm điểm sản phẩm');
      expect(
        SellerPledgePresenter.titleForStep(3),
        'Bước 3: Xác nhận ghi nhận',
      );
      expect(
        SellerPledgePresenter.titleForStep(99),
        'Bước 3: Xác nhận ghi nhận',
      );
    });

    test('normalizedScore trims input and falls back for blank values', () {
      expect(SellerPledgePresenter.normalizedScore(' 9.2 '), '9.2');
      expect(SellerPledgePresenter.normalizedScore(''), '8.5');
      expect(SellerPledgePresenter.normalizedScore('   '), '8.5');
    });
  });
}
