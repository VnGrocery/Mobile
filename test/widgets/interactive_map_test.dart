import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/widgets/interactive_map.dart';
import 'package:vngrocery/widgets/map_projection.dart';

const _center = GeoPoint(10.7721, 106.6980);
const _viewport = Size(400, 400);

/// Renders the map and reports every camera it publishes.
///
/// The maths of dragging and pinching is covered in map_camera_test.dart; this
/// only checks that gestures reach it and that a preview stays inert.
Future<List<MapCamera>> _pump(
  WidgetTester tester, {
  bool interactive = true,
}) async {
  final reported = <MapCamera>[];

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: _viewport.width,
          height: _viewport.height,
          child: InteractiveMap(
            initialCamera: const MapCamera(center: _center, zoom: 13),
            interactive: interactive,
            onCameraChanged: reported.add,
            overlayBuilder: (context, projection) => const SizedBox.shrink(),
          ),
        ),
      ),
    ),
  );
  return reported;
}

/// Tears the tree down so the tile images' pending work does not outlive the
/// test.
Future<void> _teardown(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a drag reaches the camera', (tester) async {
    final reported = await _pump(tester);

    await tester.drag(find.byType(InteractiveMap), const Offset(-100, 0));
    await tester.pump();

    expect(reported, isNotEmpty);
    // Dragging left carries the land left, so the centre moves east.
    expect(reported.last.center.longitude, greaterThan(_center.longitude));

    await _teardown(tester);
  });

  testWidgets('the overlay is drawn with the camera as it stands', (
    tester,
  ) async {
    MapProjection? seen;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: _viewport.width,
            height: _viewport.height,
            child: InteractiveMap(
              initialCamera: const MapCamera(center: _center, zoom: 13),
              overlayBuilder: (context, projection) {
                seen = projection;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );

    // Pins and rings project against this, so it has to match the tiles under
    // them, viewport included.
    expect(seen?.center, _center);
    expect(seen?.zoom, 13);
    expect(seen?.viewport, _viewport);

    await _teardown(tester);
  });

  testWidgets('a double tap zooms in without the drag recogniser eating it', (
    tester,
  ) async {
    final reported = await _pump(tester);

    // Both a scale and a double-tap recogniser sit on the same detector; if the
    // scale one claims the pointer on the first tap the zoom never happens.
    await tester.tapAt(const Offset(120, 90));
    await tester.pump(kDoubleTapMinTime);
    await tester.tapAt(const Offset(120, 90));
    await tester.pump();

    expect(reported, isNotEmpty);
    expect(reported.last.zoom, 14);

    await _teardown(tester);
  });

  testWidgets('a preview ignores gestures so the page can scroll', (
    tester,
  ) async {
    final reported = await _pump(tester, interactive: false);

    await tester.drag(find.byType(InteractiveMap), const Offset(-100, 0));
    await tester.pump();

    expect(reported, isEmpty);

    await _teardown(tester);
  });
}
