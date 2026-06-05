import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/seller_shop/seller_shop_presenter.dart';

void main() {
  group('SellerShopPresenter', () {
    test('effectiveShopId falls back to demo shop id', () {
      expect(SellerShopPresenter.effectiveShopId(null), 's1');
      expect(SellerShopPresenter.effectiveShopId('s9'), 's9');
    });
  });
}
