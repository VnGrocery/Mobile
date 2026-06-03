import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/products/controllers/product_detail_cubit.dart';

void main() {
  test('ProductDetailCubit loads product by id', () {
    final product = AppRepositories.instance.products.all().first;
    final cubit = ProductDetailCubit();

    cubit.load(product.id);

    expect(cubit.state.hasProduct, isTrue);
    expect(cubit.state.product?.id, product.id);

    cubit.close();
  });
}
