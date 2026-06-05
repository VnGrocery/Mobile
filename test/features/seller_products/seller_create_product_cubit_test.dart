import 'package:vngrocery/core/services/app_delay_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/app_data_config.dart';
import 'package:vngrocery/features/seller_products/controllers/seller_create_product_cubit.dart';

void main() {
  test('SellerCreateProductCubit updates category and image state', () {
    final cubit = SellerCreateProductCubit(
      shopId: AppDataConfig.demoShopId,
      delayService: const NoopAppDelayService(),
    );

    cubit.setCategory('Khác');
    cubit.toggleImage();

    expect(cubit.state.category, 'Khác');
    expect(cubit.state.imageSelected, isTrue);

    cubit.close();
  });

  test('SellerCreateProductCubit saves draft product', () async {
    final cubit = SellerCreateProductCubit(
      shopId: AppDataConfig.demoShopId,
      delayService: const NoopAppDelayService(),
    );

    final product = await cubit.save(
      name: 'Test product',
      description: 'Description',
      price: '120.000 đ',
      tags: 'Demo, Fresh',
    );

    expect(product.shopId, AppDataConfig.demoShopId);
    expect(product.price, 120000);
    expect(product.tags, ['Demo', 'Fresh']);
    expect(product.status, 'Draft');
    expect(cubit.state.saved, isTrue);
    expect(cubit.state.saving, isFalse);

    cubit.close();
  });
}
