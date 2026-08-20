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

  test(
    'ProductDetailCubit survives being closed while the proof loads',
    () async {
      final product = AppRepositories.instance.products.all().first;
      final cubit = ProductDetailCubit();

      // load() continues into loadProof() asynchronously; closing underneath it
      // must not blow up with "cannot emit after close".
      final pending = cubit.load(product.id);
      await cubit.close();

      await expectLater(pending, completes);
    },
  );

  test('ProductDetailCubit leaves proof null when there is no backend', () async {
    final product = AppRepositories.instance.products.all().first;
    final cubit = ProductDetailCubit();

    await cubit.load(product.id);

    expect(cubit.state.hasProduct, isTrue);
    // No RemoteDataSource is configured in tests, so the badge is simply absent
    // and the rest of the screen still renders.
    expect(cubit.state.proof, isNull);

    await cubit.close();
  });
}
