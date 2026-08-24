import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/location/location_service.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/controllers/home_state.dart';

/// Bến Thành market, District 1.
const _origin = GeoPoint(10.7721, 106.6980);

Shop _shop(String id, {double lat = 0, double lng = 0, double rating = 5}) =>
    Shop(
      id: id,
      name: 'Shop $id',
      address: 'addr',
      rating: rating,
      reviewCount: 2,
      description: '',
      latitude: lat,
      longitude: lng,
    );

HomeState _state(List<Shop> shops, {ReaderLocation? at}) =>
    HomeState(shops: shops, location: at);

void main() {
  // 1 km, 4 km and 10 km due north of Bến Thành.
  final near = _shop('near', lat: 10.7811, lng: 106.6980);
  final mid = _shop('mid', lat: 10.8081, lng: 106.6980);
  final far = _shop('far', lat: 10.8621, lng: 106.6980);
  final here = const ReaderLocation(point: _origin, areaName: 'Quận 1');

  group('home ordering by distance', () {
    test('shops are nearest first', () {
      final state = _state([far, near, mid], at: here);

      expect(state.nearbyShops.items.map((e) => e.item.id), ['near', 'mid']);
    });

    test('carries the distance so the card can show it', () {
      final state = _state([near], at: here);

      expect(state.nearbyShops.items.single.distanceKm, closeTo(1, 0.1));
    });

    test('the 10 km shop is hidden while a closer one exists', () {
      final state = _state([far, near], at: here);

      expect(state.nearbyShops.items.map((e) => e.item.id), ['near']);
    });

    test('widens past 5 km only when nothing is closer', () {
      final state = _state([far], at: here);

      expect(state.nearbyShops.items.map((e) => e.item.id), ['far']);
    });

    test('top rated is limited to shops in range', () {
      // The far shop is rated higher, but it is not somewhere anyone is buying
      // fresh produce today.
      final state = _state([
        _shop('far', lat: 10.8621, lng: 106.6980, rating: 5),
        _shop('near', lat: 10.7811, lng: 106.6980, rating: 3),
      ], at: here);

      expect(state.topRatedShops.map((s) => s.id), ['near']);
    });

    test('without a location nothing is reordered or dropped', () {
      final state = _state([far, near, mid]);

      expect(state.nearbyShops.items.map((e) => e.item.id), [
        'far',
        'near',
        'mid',
      ]);
      expect(
        state.nearbyShops.items.every((e) => e.distanceKm == null),
        isTrue,
      );
    });

    test('standing outside the radius still shows the closest shops', () {
      // The demo-day case: locate somewhere the catalogue does not cover and
      // the alternative is a blank screen that looks like a failure.
      final state = _state(
        [far, near, mid],
        at: const ReaderLocation(
          point: GeoPoint(21.0278, 105.8342), // Hanoi, ~1150 km away
        ),
      );

      expect(state.outsideRange, isTrue);
      expect(state.nearbyShops.items, isNotEmpty);
      // Still nearest first, just nowhere near.
      expect(state.nearbyShops.items.first.item.id, 'far');
    });

    test('inside the radius nothing claims to be out of range', () {
      expect(_state([near], at: here).outsideRange, isFalse);
    });

    test('a shop with no coordinates is kept, after the located ones', () {
      final state = _state([_shop('noCoords'), near], at: here);

      expect(state.nearbyShops.items.map((e) => e.item.id), [
        'near',
        'noCoords',
      ]);
    });
  });
}
