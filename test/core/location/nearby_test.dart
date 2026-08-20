import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/location/nearby.dart';

/// Bến Thành market, District 1.
const _origin = GeoPoint(10.7721, 106.6980);

class _Shop {
  final String name;
  final GeoPoint? at;

  const _Shop(this.name, this.at);
}

List<Nearby<_Shop>> _rank(List<_Shop> shops, {GeoPoint? origin = _origin}) =>
    rankByDistance(shops, origin: origin, locate: (shop) => shop.at);

void main() {
  group('distanceKm', () {
    test('is zero at the same point', () {
      expect(distanceKm(_origin, _origin), closeTo(0, 0.0001));
    });

    test('matches a known distance across the city', () {
      // Bến Thành to Thủ Đức: 0.0741° of latitude is 8.24 km and 0.0823° of
      // longitude at this latitude is 8.99 km, so the hypotenuse is 12.2 km.
      final km = distanceKm(_origin, const GeoPoint(10.8462, 106.7803));
      expect(km, closeTo(12.2, 0.1));
    });

    test('is symmetric', () {
      const other = GeoPoint(10.4114, 106.9548);
      expect(
        distanceKm(_origin, other),
        closeTo(distanceKm(other, _origin), 1e-9),
      );
    });
  });

  group('offsetKm', () {
    test('north and south move latitude the right way', () {
      expect(
        offsetKm(_origin, northKm: 5).latitude,
        greaterThan(_origin.latitude),
      );
      expect(
        offsetKm(_origin, northKm: -5).latitude,
        lessThan(_origin.latitude),
      );
    });

    test('lands the distance it was asked for', () {
      for (final km in [1.0, 5.0, 20.0]) {
        expect(
          distanceKm(_origin, offsetKm(_origin, northKm: km)),
          closeTo(km, km * 0.01),
        );
        expect(
          distanceKm(_origin, offsetKm(_origin, eastKm: km)),
          closeTo(km, km * 0.01),
        );
      }
    });

    test('a kilometre east is more degrees the further from the equator', () {
      // Lines of longitude converge towards the poles.
      const equator = GeoPoint(0, 0);
      const north = GeoPoint(60, 0);

      final atEquator = offsetKm(equator, eastKm: 10).longitude;
      final upNorth = offsetKm(north, eastKm: 10).longitude;

      expect(upNorth, greaterThan(atEquator));
      // cos(60 deg) is a half, so it takes twice the degrees.
      expect(upNorth, closeTo(atEquator * 2, atEquator * 0.01));
    });
  });

  group('selectNearby', () {
    NearbySelection<_Shop> select(
      List<_Shop> shops, {
      GeoPoint? origin = _origin,
    }) => selectNearby(shops, origin: origin, locate: (shop) => shop.at);

    test('inside the rings it behaves exactly like the ranking', () {
      final selection = select(const [
        _Shop('far', GeoPoint(10.8621, 106.6980)), // ~10 km
        _Shop('near', GeoPoint(10.7811, 106.6980)), // ~1 km
      ]);

      expect(selection.items.map((e) => e.item.name), ['near']);
      expect(selection.outsideRange, isFalse);
    });

    test('nothing in range falls back to the closest that exist', () {
      // The demo case: the reader is somewhere the catalogue does not cover, so
      // a blank screen would be the alternative.
      final selection = select(const [
        _Shop('canGio', GeoPoint(10.4114, 106.9548)), // ~40 km
        _Shop('hanoi', GeoPoint(21.0278, 105.8342)), // ~1150 km
      ]);

      expect(selection.items.map((e) => e.item.name), ['canGio', 'hanoi']);
      expect(selection.outsideRange, isTrue);
    });

    test('the fallback is capped so it does not dump the whole catalogue', () {
      final far = [
        for (var i = 0; i < 30; i++)
          _Shop('far\$i', GeoPoint(20.0 + i * 0.01, 106.6980)),
      ];

      expect(select(far, origin: _origin).items, hasLength(10));
    });

    test('the fallback is still nearest first', () {
      final selection = select(const [
        _Shop('hanoi', GeoPoint(21.0278, 105.8342)),
        _Shop('canGio', GeoPoint(10.4114, 106.9548)),
      ]);

      expect(selection.items.first.item.name, 'canGio');
    });

    test('with no location it does not claim anything is out of range', () {
      final selection = select(const [
        _Shop('a', GeoPoint(21.0278, 105.8342)),
      ], origin: null);

      expect(selection.outsideRange, isFalse);
      expect(selection.items, hasLength(1));
    });

    test('an empty catalogue stays empty rather than inventing a fallback', () {
      expect(select(const []).isEmpty, isTrue);
      expect(select(const [_Shop('nowhere', null)]).items, hasLength(1));
    });
  });

  group('rankByDistance', () {
    test('sorts the near ring by how close it is', () {
      final ranked = _rank(const [
        _Shop('3km', GeoPoint(10.7991, 106.6980)),
        _Shop('1km', GeoPoint(10.7811, 106.6980)),
        _Shop('2km', GeoPoint(10.7901, 106.6980)),
      ]);

      expect(ranked.map((e) => e.item.name), ['1km', '2km', '3km']);
      expect(ranked.first.distanceKm, closeTo(1, 0.1));
    });

    test('hides the far ring while anything is within 5 km', () {
      final ranked = _rank(const [
        _Shop('far', GeoPoint(10.8621, 106.6980)), // ~10 km
        _Shop('near', GeoPoint(10.8081, 106.6980)), // ~4 km
      ]);

      expect(ranked.map((e) => e.item.name), ['near']);
    });

    test('widens to 20 km only when nothing is within 5 km', () {
      final ranked = _rank(const [
        _Shop('18km', GeoPoint(10.9341, 106.6980)),
        _Shop('10km', GeoPoint(10.8621, 106.6980)),
      ]);

      expect(ranked.map((e) => e.item.name), ['10km', '18km']);
    });

    test('drops anything past the far ring', () {
      // Cần Giờ is ~40 km out; past 20 km it is not "nearby" in any useful
      // sense, so it is left out rather than shown as a suggestion.
      final ranked = _rank(const [
        _Shop('canGio', GeoPoint(10.4114, 106.9548)),
      ]);

      expect(ranked, isEmpty);
    });

    test('keeps shops that never filled in coordinates, last', () {
      final ranked = _rank(const [
        _Shop('noAddress', null),
        _Shop('unset', GeoPoint(0, 0)),
        _Shop('near', GeoPoint(10.7811, 106.6980)),
      ]);

      expect(ranked.map((e) => e.item.name), ['near', 'noAddress', 'unset']);
      expect(ranked.last.isLocated, isFalse);
    });

    test('without a location the original order is untouched', () {
      final ranked = _rank(const [
        _Shop('b', GeoPoint(10.8621, 106.6980)),
        _Shop('a', GeoPoint(10.7811, 106.6980)),
      ], origin: null);

      expect(ranked.map((e) => e.item.name), ['b', 'a']);
      expect(ranked.every((e) => e.distanceKm == null), isTrue);
    });

    test('an origin of (0, 0) counts as no location', () {
      final ranked = _rank(const [
        _Shop('b', GeoPoint(10.8621, 106.6980)),
        _Shop('a', GeoPoint(10.7811, 106.6980)),
      ], origin: const GeoPoint(0, 0));

      expect(ranked.map((e) => e.item.name), ['b', 'a']);
    });
  });
}
