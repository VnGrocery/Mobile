import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/explore/controllers/explore_cubit.dart';

void main() {
  test('ExploreCubit loads shops', () {
    final cubit = ExploreCubit();

    cubit.load();

    expect(cubit.state.shops, isNotEmpty);
    expect(cubit.state.selectedFilter, isNotEmpty);

    cubit.close();
  });

  test('ExploreCubit filters shops by query and clears selection', () {
    final cubit = ExploreCubit()..load();
    final firstShop = cubit.state.shops.first;
    cubit.selectShop(firstShop.id);

    cubit.setQuery(firstShop.name);

    final query = firstShop.name.toLowerCase();
    expect(
      cubit.state.shops.every(
        (shop) =>
            shop.name.toLowerCase().contains(query) ||
            shop.address.toLowerCase().contains(query),
      ),
      isTrue,
    );
    expect(cubit.state.selectedShopId, isNull);

    cubit.close();
  });

  test('ExploreCubit selects shop from filtered results', () {
    final cubit = ExploreCubit()..load();
    final firstShop = cubit.state.shops.first;

    cubit.selectShop(firstShop.id);

    expect(cubit.state.selectedShop?.id, firstShop.id);

    cubit.close();
  });
}
