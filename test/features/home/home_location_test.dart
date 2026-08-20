import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/location/location_service.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/controllers/home_state.dart';
import 'package:vngrocery/features/home/home_presenter.dart';

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

Product _product(String id, Shop shop) => Product(
  id: id,
  shopId: shop.id,
  name: 'p$id',
  description: '',
  category: 'fruit',
  price: 1000,
  freshnessScore: 8,
  freshnessNote: '',
  tags: const [],
  imageUrls: const [],
  status: 'published',
);

HomeState _state(List<Shop> shops, {ReaderLocation? at}) => HomeState(
  shops: shops,
  pledgeItems: [
    for (final shop in shops)
      HomePledgeItem(product: _product(shop.id, shop), shop: shop),
  ],
  location: at,
);

void main() {
  // 1 km, 4 km and 10 km due north of Bến Thành.
  final near = _shop('near', lat: 10.7811, lng: 106.6980);
  final mid = _shop('mid', lat: 10.8081, lng: 106.6980);
  final far = _shop('far', lat: 10.8621, lng: 106.6980);
  final here = const ReaderLocation(point: _origin, areaName: 'Quận 1');

  group('home ordering by distance', () {
    test('recent checks are nearest first', () {
      final state = _state([far, near, mid], at: here);

      expect(state.featuredPledgeItems().map((e) => e.item.shop.id), [
        'near',
        'mid',
      ]);
    });

    test('carries the distance so the card can show it', () {
      final state = _state([near], at: here);

      expect(state.featuredPledgeItems().single.distanceKm, closeTo(1, 0.1));
    });

    test('the 10 km shop is hidden while a closer one exists', () {
      final state = _state([far, near], at: here);

      expect(state.nearbyShops.map((e) => e.item.id), ['near']);
    });

    test('widens past 5 km only when nothing is closer', () {
      final state = _state([far], at: here);

      expect(state.nearbyShops.map((e) => e.item.id), ['far']);
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

      expect(state.nearbyShops.map((e) => e.item.id), ['far', 'near', 'mid']);
      expect(
        state.featuredPledgeItems().every((e) => e.distanceKm == null),
        isTrue,
      );
    });

    test('a shop with no coordinates is kept, after the located ones', () {
      final state = _state([_shop('noCoords'), near], at: here);

      expect(state.nearbyShops.map((e) => e.item.id), ['near', 'noCoords']);
    });
  });
}
