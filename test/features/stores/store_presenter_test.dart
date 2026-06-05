import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/stores/store_presenter.dart';

void main() {
  test('StorePresenter.shareText formats shop summary', () {
    const shop = Shop(
      id: 's1',
      name: 'Chợ Xanh',
      address: '12 Nguyễn Trãi',
      rating: 4.7,
      reviewCount: 128,
      description: 'Cửa hàng thực phẩm sạch',
    );

    expect(
      StorePresenter.shareText(shop),
      'Chợ Xanh\n12 Nguyễn Trãi\n4.7 điểm đánh giá - 128 lượt đánh giá',
    );
  });
}
