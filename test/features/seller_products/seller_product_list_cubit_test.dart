import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/app_data_config.dart';
import 'package:vngrocery/features/seller_products/controllers/seller_product_list_cubit.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';

void main() {
  test('SellerProductListCubit loads all seller products by default', () {
    final cubit = SellerProductListCubit(shopId: AppDataConfig.demoShopId);

    cubit.load();

    expect(cubit.state.products, isNotEmpty);
    expect(cubit.state.selectedState, SellerProductPresenter.states.first);

    cubit.close();
  });

  test('SellerProductListCubit filters products by status', () {
    final cubit = SellerProductListCubit(shopId: AppDataConfig.demoShopId);

    cubit.setStateFilter('Draft');

    expect(cubit.state.selectedState, 'Draft');
    expect(
      cubit.state.products.every((product) => product.status == 'Draft'),
      isTrue,
    );

    cubit.close();
  });
}
