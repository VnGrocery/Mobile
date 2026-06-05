import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/widgets/osm_tile_map.dart';

void main() {
  Widget host(Widget child) => MaterialApp(
    home: Scaffold(body: SizedBox(width: 400, height: 400, child: child)),
  );

  testWidgets('renders OSM tiles and attribution', (tester) async {
    final requested = <String>[];

    await tester.pumpWidget(
      host(
        OsmTileMap(
          latitude: 10.7769,
          longitude: 106.7009,
          tileUriBuilder: (zoom, x, y) {
            requested.add('$zoom/$x/$y');
            return Uri.parse('https://tiles.test/$zoom/$x/$y.png');
          },
        ),
      ),
    );

    expect(find.byType(Image), findsNWidgets(16));
    expect(find.text('© OpenStreetMap contributors'), findsOneWidget);
    expect(requested.first, '13/6523/3848');
    expect(requested.last, '13/6526/3851');
  });

  testWidgets('uses custom provider URL, attribution, and semantics', (
    tester,
  ) async {
    final requested = <String>[];
    final config = OsmTileProviderConfig(
      tileUriBuilder: (zoom, x, y) {
        requested.add('$zoom/$x/$y');
        return Uri.parse('https://tiles.example.com/$zoom/$x/$y.png');
      },
      attribution: '© Example Maps',
      minZoom: 0,
      maxZoom: 18,
      semanticLabel: 'Example map tile',
    );

    await tester.pumpWidget(
      host(
        OsmTileMap(
          latitude: 10.7769,
          longitude: 106.7009,
          providerConfig: config,
        ),
      ),
    );

    expect(find.text('© Example Maps'), findsOneWidget);
    expect(requested.first, '13/6523/3848');
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image && widget.semanticLabel == 'Example map tile',
      ),
      findsNWidgets(16),
    );
  });

  testWidgets('tileUriBuilder overrides provider config builder', (
    tester,
  ) async {
    final providerRequested = <String>[];
    final overrideRequested = <String>[];
    final config = OsmTileProviderConfig(
      tileUriBuilder: (zoom, x, y) {
        providerRequested.add('$zoom/$x/$y');
        return Uri.parse('https://provider.test/$zoom/$x/$y.png');
      },
      attribution: '© Provider',
      minZoom: 0,
      maxZoom: 18,
    );

    await tester.pumpWidget(
      host(
        OsmTileMap(
          latitude: 10.7769,
          longitude: 106.7009,
          providerConfig: config,
          tileUriBuilder: (zoom, x, y) {
            overrideRequested.add('$zoom/$x/$y');
            return Uri.parse('https://override.test/$zoom/$x/$y.png');
          },
        ),
      ),
    );

    expect(providerRequested, isEmpty);
    expect(overrideRequested, isNotEmpty);
    expect(find.text('© Provider'), findsOneWidget);
  });

  testWidgets('wraps antimeridian tile x coordinates', (tester) async {
    final requested = <String>[];

    await tester.pumpWidget(
      host(
        OsmTileMap(
          latitude: 0,
          longitude: -540,
          zoom: 2,
          tileUriBuilder: (zoom, x, y) {
            requested.add('$zoom/$x/$y');
            return Uri.parse('https://tiles.test/$zoom/$x/$y.png');
          },
        ),
      ),
    );

    expect(
      requested.map((tile) => tile.split('/')[1]),
      containsAll(<String>['3', '0', '1', '2']),
    );
  });

  testWidgets('clamps zoom, latitude, and tile bounds', (tester) async {
    final requested = <String>[];

    await tester.pumpWidget(
      host(
        OsmTileMap(
          latitude: 120,
          longitude: -540,
          zoom: 30,
          tileUriBuilder: (zoom, x, y) {
            requested.add('$zoom/$x/$y');
            return Uri.parse('https://tiles.test/$zoom/$x/$y.png');
          },
        ),
      ),
    );

    expect(requested, isNotEmpty);
    expect(requested.every((tile) => tile.startsWith('19/')), isTrue);
    for (final tile in requested) {
      final parts = tile.split('/').map(int.parse).toList();
      expect(parts[1], inInclusiveRange(0, 524287));
      expect(parts[2], inInclusiveRange(0, 524287));
    }
  });

  testWidgets('uses provider min and max zoom clamps', (tester) async {
    final requested = <String>[];
    final config = OsmTileProviderConfig(
      tileUriBuilder: (zoom, x, y) {
        requested.add('$zoom/$x/$y');
        return Uri.parse('https://tiles.test/$zoom/$x/$y.png');
      },
      attribution: '© Example Maps',
      minZoom: 3,
      maxZoom: 17,
    );

    await tester.pumpWidget(
      host(
        OsmTileMap(latitude: 0, longitude: 0, zoom: 30, providerConfig: config),
      ),
    );
    expect(requested.every((tile) => tile.startsWith('17/')), isTrue);

    requested.clear();
    await tester.pumpWidget(
      host(
        OsmTileMap(latitude: 0, longitude: 0, zoom: -5, providerConfig: config),
      ),
    );
    expect(requested.every((tile) => tile.startsWith('3/')), isTrue);
  });
}
