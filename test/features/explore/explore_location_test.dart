import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/location/location_service.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/explore/controllers/explore_cubit.dart';
import 'package:vngrocery/features/explore/explore_presenter.dart';

class _FixedLocation implements LocationService {
  const _FixedLocation();

  @override
  Future<(ReaderLocation?, LocationDenial?)> current() async => (
    const ReaderLocation(
      point: GeoPoint(10.7721, 106.6980),
      areaName: 'Quận 1',
    ),
    null,
  );
}

Shop _shop(String id, double lat, {double rating = 3}) => Shop(
  id: id,
  name: 'Shop $id',
  address: 'addr',
  rating: rating,
  reviewCount: 1,
  description: '',
  latitude: lat,
  longitude: 106.6980,
);

void main() {
  setUp(() {
    MockDb.instance.shops
      ..clear()
      ..addAll([
        _shop('far', 10.8621, rating: 5),
        _shop('near', 10.7811, rating: 1),
      ]);
  });

  tearDown(MockDb.instance.resetForTesting);

  test('locating the reader switches to ordering by distance', () async {
    final cubit = ExploreCubit(location: const _FixedLocation())..load();

    await cubit.locateReader();

    expect(cubit.state.selectedFilter, ExploreFilters.nearby);
    // The far shop is rated higher but is outside the 5 km ring.
    expect(cubit.state.shops.map((s) => s.id), ['near']);
    cubit.close();
  });

  test('a chip the reader picked is not overridden by a later fix', () async {
    final cubit = ExploreCubit(location: const _FixedLocation())..load();

    cubit.setFilter(ExploreFilters.topRated);
    await cubit.locateReader();

    expect(cubit.state.selectedFilter, ExploreFilters.topRated);
    expect(cubit.state.shops.first.id, 'far');
    cubit.close();
  });
}
