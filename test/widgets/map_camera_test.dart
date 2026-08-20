import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/widgets/interactive_map.dart';
import 'package:vngrocery/widgets/map_projection.dart';

const _center = GeoPoint(10.7721, 106.6980);
const _viewport = Size(400, 400);
const _start = MapCamera(center: _center, zoom: 13);

MapCamera _drag(Offset by, {MapCamera from = _start}) => MapCamera.transformed(
  start: from,
  viewport: _viewport,
  focalStart: const Offset(200, 200),
  focalNow: const Offset(200, 200) + by,
);

MapProjection _projectionFor(MapCamera camera) => MapProjection(
  center: camera.center,
  zoom: camera.zoom,
  viewport: _viewport,
);

void main() {
  group('dragging', () {
    test('moves the map with the finger, not against it', () {
      // Dragging left carries the land left, so the centre moves east.
      expect(
        _drag(const Offset(-100, 0)).center.longitude,
        greaterThan(_center.longitude),
      );
      expect(
        _drag(const Offset(100, 0)).center.longitude,
        lessThan(_center.longitude),
      );
      // Dragging down carries the land down, so the centre moves north.
      expect(
        _drag(const Offset(0, 100)).center.latitude,
        greaterThan(_center.latitude),
      );
      expect(
        _drag(const Offset(0, -100)).center.latitude,
        lessThan(_center.latitude),
      );
    });

    test('leaves the zoom alone', () {
      expect(_drag(const Offset(-100, 60)).zoom, 13);
    });

    test('keeps the place under the finger under it', () {
      const grabAt = Offset(120, 90);
      final grabbed = _projectionFor(_start).unproject(grabAt);
      const by = Offset(-60, 40);

      final landedAt = _projectionFor(_drag(by, from: _start)).project(grabbed);

      expect(landedAt.dx, closeTo(grabAt.dx + by.dx, 0.001));
      expect(landedAt.dy, closeTo(grabAt.dy + by.dy, 0.001));
    });

    test('a long drag in steps ends where one big drag would', () {
      // Every update is measured from the start of the gesture, so rounding
      // cannot accumulate into drift.
      var stepped = _start;
      for (var i = 1; i <= 10; i++) {
        stepped = MapCamera.transformed(
          start: _start,
          viewport: _viewport,
          focalStart: const Offset(200, 200),
          focalNow: Offset(200 - i * 10.0, 200),
        );
      }
      final direct = _drag(const Offset(-100, 0));

      expect(stepped.center.longitude, closeTo(direct.center.longitude, 1e-12));
    });
  });

  group('pinching', () {
    MapCamera pinch(double scale, {Offset at = const Offset(200, 200)}) =>
        MapCamera.transformed(
          start: _start,
          viewport: _viewport,
          focalStart: at,
          focalNow: at,
          scale: scale,
        );

    test('doubling the span zooms in exactly one level', () {
      expect(pinch(2).zoom, closeTo(14, 1e-12));
      expect(pinch(0.5).zoom, closeTo(12, 1e-12));
      expect(pinch(4).zoom, closeTo(15, 1e-12));
    });

    test('keeps the midpoint of the fingers pinned', () {
      const at = Offset(140, 260);
      final held = _projectionFor(_start).unproject(at);

      final landedAt = _projectionFor(pinch(3, at: at)).project(held);

      expect(landedAt.dx, closeTo(at.dx, 0.001));
      expect(landedAt.dy, closeTo(at.dy, 0.001));
    });

    test('stays within the zoom bounds', () {
      final tooFarIn = MapCamera.transformed(
        start: _start,
        viewport: _viewport,
        focalStart: const Offset(200, 200),
        focalNow: const Offset(200, 200),
        scale: math.pow(2, 20).toDouble(),
        maxZoom: 18,
      );
      final tooFarOut = MapCamera.transformed(
        start: _start,
        viewport: _viewport,
        focalStart: const Offset(200, 200),
        focalNow: const Offset(200, 200),
        scale: math.pow(2, -20).toDouble(),
        minZoom: 3,
      );

      expect(tooFarIn.zoom, 18);
      expect(tooFarOut.zoom, 3);
    });

    test('a scale of zero is ignored rather than sending zoom to infinity', () {
      // The gesture recogniser can report 0 on the frame a second finger lands.
      expect(pinch(0).zoom, 13);
    });
  });

  test('the poles are the end of the map, not a way past it', () {
    final north = MapCamera.transformed(
      start: _start,
      viewport: _viewport,
      focalStart: const Offset(200, 200),
      // The world is 256 * 2^13 px tall at this zoom, so this drag would carry
      // the centre well past the north pole.
      focalNow: const Offset(200, 3000000),
    );

    expect(north.center.latitude, lessThanOrEqualTo(MapProjection.maxLatitude));
    expect(north.center.latitude, closeTo(MapProjection.maxLatitude, 0.001));
  });

  test('an empty viewport leaves the camera alone', () {
    // Laid out but not measured yet; there is nothing to project against.
    final unchanged = MapCamera.transformed(
      start: _start,
      viewport: Size.zero,
      focalStart: const Offset(10, 10),
      focalNow: const Offset(90, 90),
    );

    expect(unchanged, _start);
  });
}
