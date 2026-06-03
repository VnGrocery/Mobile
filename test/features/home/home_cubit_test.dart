import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/home/controllers/home_cubit.dart';

void main() {
  test('HomeCubit loads shops, products, and pledge items', () {
    final cubit = HomeCubit();

    cubit.load();

    expect(cubit.state.shops, isNotEmpty);
    expect(cubit.state.products, isNotEmpty);
    expect(cubit.state.pledgeItems.length, cubit.state.products.length);
    expect(cubit.state.featuredPledgeItems().length, lessThanOrEqualTo(3));

    cubit.close();
  });
}
