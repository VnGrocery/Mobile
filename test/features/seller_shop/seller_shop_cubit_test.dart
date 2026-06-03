import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/app_data_config.dart';
import 'package:vngrocery/features/seller_shop/controllers/seller_shop_cubit.dart';

void main() {
  test('SellerShopCubit loads shop and dashboard', () {
    final cubit = SellerShopCubit(shopId: AppDataConfig.demoShopId);

    cubit.load();

    expect(cubit.state.shop?.id, AppDataConfig.demoShopId);
    expect(cubit.state.dashboard?.shop.id, AppDataConfig.demoShopId);

    cubit.close();
  });

  test('SellerShopCubit saves shop profile', () async {
    final cubit = SellerShopCubit(shopId: AppDataConfig.demoShopId)..load();

    await cubit.save(
      name: 'Demo Shop Updated',
      description: 'Updated description',
      address: 'Updated address',
    );

    expect(cubit.state.saving, isFalse);
    expect(cubit.state.shop?.name, 'Demo Shop Updated');
    expect(cubit.state.dashboard?.shop.name, 'Demo Shop Updated');

    cubit.close();
  });
}
