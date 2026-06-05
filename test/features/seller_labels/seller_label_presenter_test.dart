import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/seller_labels/seller_label_presenter.dart';

void main() {
  test('SellerLabelPresenter builds stable clipboard text', () {
    expect(
      SellerLabelPresenter.clipboardText('pl-01'),
      'VnGrocery Check\nMã ghi nhận: pl-01\nQuét mã để kiểm tra thông tin sản phẩm',
    );
  });
}
