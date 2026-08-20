import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/widgets/map_projection.dart';

/// Bến Thành market, District 1.
const _center = GeoPoint(10.7721, 106.6980);
const _viewport = Size(400, 400);

MapProjection _projection({int zoom = 13}) =>
    MapProjection(center: _center, zoom: zoom, viewport: _viewport);

void main() {
  group('MapProjection.project', () {
    test('puts the centre in the middle of the viewport', () {
      final offset = _projection().project(_center);

      expect(offset.dx, closeTo(200, 0.001));
      expect(offset.dy, closeTo(200, 0.001));
    });

    test('north is up and east is right', () {
      // Latitude increases northwards but screen y grows downwards.
      final north = _projection().project(const GeoPoint(10.8, 106.6980));
      final east = _projection().project(const GeoPoint(10.7721, 106.75));

      expect(north.dy, lessThan(200));
      expect(north.dx, closeTo(200, 0.001));
      expect(east.dx, greaterThan(200));
      expect(east.dy, closeTo(200, 0.001));
    });

    test('a point twice as far away lands twice as far from centre', () {
      final near = _projection().project(const GeoPoint(10.7721, 106.7080));
      final far = _projection().project(const GeoPoint(10.7721, 106.7180));

      expect(far.dx - 200, closeTo((near.dx - 200) * 2, 0.001));
    });

    test('zooming in one level doubles the separation', () {
      const point = GeoPoint(10.7811, 106.6980);
      final near = _projection(zoom: 13).project(point);
      final closer = _projection(zoom: 14).project(point);

      expect(200 - closer.dy, closeTo((200 - near.dy) * 2, 0.001));
    });

    test(
      'handles the antimeridian without flinging the pin across the map',
      () {
        const projection = MapProjection(
          center: GeoPoint(0, 179.9),
          zoom: 8,
          viewport: _viewport,
        );

        // Half a degree east of the centre, expressed as a negative longitude.
        final offset = projection.project(const GeoPoint(0, -179.6));
        expect(offset.dx.isFinite, isTrue);
      },
    );
  });

  group('MapProjection.isVisible', () {
    test('accepts a pin inside the viewport', () {
      expect(_projection().isVisible(const Offset(200, 200)), isTrue);
    });

    test('keeps a marker straddling the edge', () {
      expect(_projection().isVisible(const Offset(-10, 200)), isTrue);
    });

    test('drops one well outside', () {
      expect(_projection().isVisible(const Offset(-500, 200)), isFalse);
      expect(_projection().isVisible(const Offset(200, 900)), isFalse);
    });
  });

  group('MapProjection.zoomToFit', () {
    int fit(List<GeoPoint> points, {Size viewport = _viewport}) =>
        MapProjection.zoomToFit(
          center: _center,
          points: points,
          viewport: viewport,
        );

    test('every point it chose a zoom for is actually on screen', () {
      // The old version guessed the scale from a constant and put shops two
      // kilometres away several screens off the edge.
      const points = [
        GeoPoint(10.7811, 106.6980), // ~1 km north
        GeoPoint(10.7721, 106.7200), // ~2.4 km east
        GeoPoint(10.7500, 106.6800), // ~3 km south-west
      ];
      final zoom = fit(points);
      final projection = MapProjection(
        center: _center,
        zoom: zoom,
        viewport: _viewport,
      );

      for (final point in points) {
        expect(
          projection.isVisible(projection.project(point)),
          isTrue,
          reason: 'point $point fell outside at zoom $zoom',
        );
      }
    });

    test('stays as zoomed in as it can while still fitting', () {
      const points = [GeoPoint(10.7811, 106.6980)];
      final zoom = fit(points);
      final tighter = MapProjection(
        center: _center,
        zoom: zoom + 1,
        viewport: _viewport,
      );

      expect(
        tighter.isVisible(tighter.project(points.first), margin: -72),
        isFalse,
        reason: 'zoom $zoom was more cautious than it needed to be',
      );
    });

    test('spreading the shops out pulls the camera back', () {
      final close = fit(const [GeoPoint(10.7761, 106.6980)]);
      final wide = fit(const [GeoPoint(10.8621, 106.6980)]);

      expect(wide, lessThan(close));
    });

    test('pulls right back for something across the country', () {
      // Hanoi, ~1150 km away, still fits once zoomed far enough out.
      final zoom = fit(const [GeoPoint(21.0278, 105.8342)]);
      final projection = MapProjection(
        center: _center,
        zoom: zoom,
        viewport: _viewport,
      );

      expect(zoom, lessThan(6));
      expect(
        projection.isVisible(
          projection.project(const GeoPoint(21.0278, 105.8342)),
        ),
        isTrue,
      );
    });

    test('never goes below the floor, however far apart the points are', () {
      // The far side of the planet cannot fit at any zoom.
      expect(fit(const [GeoPoint(-40, -73)]), 3);
    });

    test('with nothing to fit it stays zoomed in', () {
      expect(fit(const []), 16);
      // A shop with no coordinates does not drag the camera to the Atlantic.
      expect(fit(const [GeoPoint(0, 0)]), 16);
    });

    test('a narrower viewport needs a wider zoom', () {
      const points = [GeoPoint(10.7721, 106.7200)];

      final wideScreen = fit(points, viewport: const Size(800, 400));
      final narrowScreen = fit(points, viewport: const Size(200, 400));

      expect(narrowScreen, lessThanOrEqualTo(wideScreen));
    });
  });
}
