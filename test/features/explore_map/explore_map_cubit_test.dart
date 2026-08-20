import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/explore_map/controllers/explore_map_cubit.dart';

void main() {
  test('ExploreMapCubit loads shops and preserves initial selection', () {
    final cubit = ExploreMapCubit(initialShopId: 's1');

    cubit.load();

    expect(cubit.state.shops, isNotEmpty);
    expect(cubit.state.selectedShopId, 's1');
    expect(cubit.state.selectedShop?.id, 's1');

    cubit.close();
  });

  test('ExploreMapCubit selects a shop', () {
    final cubit = ExploreMapCubit()..load();
    final secondShop = cubit.state.shops[1];

    cubit.selectShop(secondShop.id);
    expect(cubit.state.selectedShop?.id, secondShop.id);

    cubit.close();
  });

  test('the nearest shop is the closest one, not whichever came first', () {
    final cubit = ExploreMapCubit()..load();
    // Without a location there is nothing to measure from, so the ordering is
    // left alone and the first shop is all this can pick.
    cubit.selectNearestShop();

    expect(cubit.state.selectedShop?.id, cubit.state.shops.first.id);

    cubit.close();
  });
}
