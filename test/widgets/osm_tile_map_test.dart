import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/widgets/map_projection.dart';
import 'package:vngrocery/widgets/osm_tile_map.dart';

/// Fits inside flutter_test's default 800x600 surface.
const _viewport = Size(400, 400);

/// Ho Chi Minh City.
const _center = GeoPoint(10.7769, 106.7009);

void main() {
  Widget host(Widget child) => MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: _viewport.width,
        height: _viewport.height,
        child: child,
      ),
    ),
  );

  /// Tiles the map asks for, as 'zoom/x/y'.
  Future<List<String>> render(
    WidgetTester tester, {
    GeoPoint center = _center,
    double zoom = 13,
    OsmTileProviderConfig? config,
  }) async {
    final requested = <String>[];
    Uri build(int z, int x, int y) {
      requested.add('$z/$x/$y');
      return Uri.parse('https://tiles.test/$z/$x/$y.png');
    }

    await tester.pumpWidget(
      host(
        OsmTileMap(
          latitude: center.latitude,
          longitude: center.longitude,
          zoom: zoom,
          providerConfig:
              config ??
              OsmTileProviderConfig(
                tileUriBuilder: build,
                attribution: '© Test Maps',
                minZoom: 0,
                maxZoom: 18,
              ),
        ),
      ),
    );
    return requested;
  }

  testWidgets('draws enough tiles to cover the viewport', (tester) async {
    final requested = await render(tester);

    // A 400x400 viewport needs ceil(400/256)+1 = 3 tiles each way to stay
    // covered whatever the fractional offset is. The old version always drew a
    // 4x4 grid stretched to fit, whatever the viewport's shape.
    const perSide = 3;
    expect(requested, hasLength(perSide * perSide));
    expect(find.byType(Image), findsNWidgets(perSide * perSide));
  });

  testWidgets('the tiles are the ones the centre falls in', (tester) async {
    final requested = await render(tester);

    // Tile the centre sits in, from the projection the pins also use.
    const projection = MapProjection(
      center: _center,
      zoom: 13,
      viewport: _viewport,
    );
    final world = projection.worldPixels(_center);
    final centreTile =
        '13/${(world.dx / mapTileSize).floor()}/${(world.dy / mapTileSize).floor()}';

    expect(requested, contains(centreTile));
  });

  testWidgets('shows the provider attribution and semantics', (tester) async {
    await render(
      tester,
      config: OsmTileProviderConfig(
        tileUriBuilder: (z, x, y) => Uri.parse('https://x/$z/$x/$y.png'),
        attribution: '© Example Maps',
        minZoom: 0,
        maxZoom: 18,
        semanticLabel: 'Example map tile',
      ),
    );

    expect(find.text('© Example Maps'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image && widget.semanticLabel == 'Example map tile',
      ),
      findsWidgets,
    );
  });

  testWidgets('wraps tile columns across the antimeridian', (tester) async {
    // Zoom 2 is a 4x4 world, so a viewport at the date line spans the seam.
    final requested = await render(
      tester,
      center: const GeoPoint(0, 179.9),
      zoom: 2,
    );

    final columns = requested.map((tile) => tile.split('/')[1]).toSet();

    // Column 4 does not exist; past the edge is column 0 on the far side.
    expect(columns, isNot(contains('4')));
    expect(columns, containsAll(<String>['3', '0']));
  });

  testWidgets('draws no tiles above the north pole', (tester) async {
    // Mercator has no imagery past the poles; the old version clamped the row
    // instead and drew the top row of the world over and over.
    final requested = await render(
      tester,
      center: const GeoPoint(85.05, 0),
      zoom: 2,
    );

    final rows = requested.map((tile) => int.parse(tile.split('/')[2]));

    expect(rows, everyElement(greaterThanOrEqualTo(0)));
    expect(rows, everyElement(lessThan(4)));
  });

  testWidgets('clamps zoom to what the provider serves', (tester) async {
    final requested = <String>[];
    Uri build(int z, int x, int y) {
      requested.add('$z/$x/$y');
      return Uri.parse('https://x/$z/$x/$y.png');
    }

    await tester.pumpWidget(
      host(
        OsmTileMap(
          latitude: _center.latitude,
          longitude: _center.longitude,
          zoom: 30,
          providerConfig: OsmTileProviderConfig(
            tileUriBuilder: build,
            attribution: '© Test Maps',
            minZoom: 2,
            maxZoom: 6,
          ),
        ),
      ),
    );

    // Asking for more detail than the provider has would fetch 404s.
    expect(requested, isNotEmpty);
    expect(requested.every((tile) => tile.startsWith('6/')), isTrue);
  });

  testWidgets('a fractional zoom scales the tiles of the nearest level', (
    tester,
  ) async {
    final requested = await render(tester, zoom: 13.25);

    // Images come from the nearest whole level; the remainder becomes the size
    // they are drawn at, so a pinch scales smoothly instead of jumping.
    expect(requested.every((tile) => tile.startsWith('13/')), isTrue);

    final tile = tester.widgetList<Positioned>(find.byType(Positioned)).first;
    expect(tile.width, closeTo(mapTileSize * math.pow(2, 0.25), 0.001));
  });
}
