import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/location/location_service.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/explore_map/controllers/explore_map_cubit.dart';
import 'package:vngrocery/features/explore_map/controllers/explore_map_state.dart';

/// Stands in for the device so the ranking can be tested without a GPS fix.
class _FixedLocation implements LocationService {
  final GeoPoint? at;

  const _FixedLocation(this.at);

  @override
  Future<(ReaderLocation?, LocationDenial?)> current() async {
    final point = at;
    if (point == null) return (null, LocationDenial.denied);
    return (ReaderLocation(point: point, areaName: 'Quận 1'), null);
  }
}

const _origin = GeoPoint(10.7721, 106.6980);

Shop _shop(String id, double lat, double lng) => Shop(
  id: id,
  name: 'Shop $id',
  address: 'addr',
  rating: 5,
  reviewCount: 1,
  description: '',
  latitude: lat,
  longitude: lng,
);

void main() {
  setUp(() {
    MockDb.instance.shops
      ..clear()
      // Deliberately listed farthest first: picking shops.first would be wrong.
      ..addAll([
        _shop('far', 10.8621, 106.6980),
        _shop('near', 10.7811, 106.6980),
      ]);
  });

  tearDown(MockDb.instance.resetForTesting);

  test('the map centres on the reader once located', () async {
    final cubit = ExploreMapCubit(location: const _FixedLocation(_origin))
      ..load();

    await cubit.locateReader();

    expect(cubit.state.center?.latitude, _origin.latitude);
    cubit.close();
  });

  test('the nearest shop is the closest one, not the first listed', () async {
    final cubit = ExploreMapCubit(location: const _FixedLocation(_origin))
      ..load();

    await cubit.locateReader();
    cubit.selectNearestShop();

    expect(cubit.state.selectedShop?.id, 'near');
    cubit.close();
  });

  test('there is nothing to centre on until locating finishes', () async {
    // Centring on a shop while the answer is still coming is what made the map
    // open on a cluster of shops instead of on the reader.
    final cubit = ExploreMapCubit(location: const _FixedLocation(_origin))
      ..load();

    expect(cubit.state.locationStatus, MapLocationStatus.locating);
    expect(cubit.state.center, isNull);

    await cubit.locateReader();

    expect(cubit.state.locationStatus, MapLocationStatus.located);
    expect(cubit.state.center, _origin);
    cubit.close();
  });

  test('a refused location leaves the map centred on a shop', () async {
    final cubit = ExploreMapCubit(location: const _FixedLocation(null))..load();

    await cubit.locateReader();

    expect(cubit.state.locationStatus, MapLocationStatus.unavailable);
    expect(cubit.state.origin, isNull);
    // Only once locating has actually failed does falling back to a shop mean
    // anything; it lands on the first with coordinates rather than on a
    // hardcoded city centre.
    expect(cubit.state.center?.latitude, 10.8621);
    cubit.close();
  });
}
