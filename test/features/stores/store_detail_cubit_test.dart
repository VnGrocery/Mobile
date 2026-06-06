import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/app_data_config.dart';
import 'package:vngrocery/features/stores/controllers/store_detail_cubit.dart';

void main() {
  test('StoreDetailCubit loads shop products and reviews', () {
    final cubit = StoreDetailCubit();

    cubit.load(AppDataConfig.demoShopId);

    expect(cubit.state.hasShop, isTrue);
    expect(cubit.state.products, isNotEmpty);
    expect(cubit.state.reviews, isNotEmpty);
    expect(cubit.state.latestProduct, cubit.state.products.first);

    cubit.close();
  });

  test('StoreDetailCubit formats share text', () {
    final cubit = StoreDetailCubit()..load(AppDataConfig.demoShopId);
    final shop = cubit.state.shop!;

    final text = cubit.shareText(shop, '4.7 điểm đánh giá - 128 lượt đánh giá');

    expect(text, contains(shop.name));
    expect(text, contains(shop.address));
    expect(text, contains('điểm đánh giá'));

    cubit.close();
  });
}
