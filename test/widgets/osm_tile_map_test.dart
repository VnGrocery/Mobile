import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/widgets/osm_tile_map.dart';

void main() {
  Widget host(Widget child) => MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 400, height: 400, child: child),
        ),
      );

  testWidgets('renders OSM tiles and attribution', (tester) async {
    final requested = <String>[];

    await tester.pumpWidget(host(OsmTileMap(
      latitude: 10.7769,
      longitude: 106.7009,
      tileUriBuilder: (zoom, x, y) {
        requested.add('$zoom/$x/$y');
        return Uri.parse('https://tiles.test/$zoom/$x/$y.png');
      },
    )));

    expect(find.byType(Image), findsNWidgets(16));
    expect(find.text('© OpenStreetMap contributors'), findsOneWidget);
    expect(requested.first, '13/6523/3848');
    expect(requested.last, '13/6526/3851');
  });

  testWidgets('clamps zoom, latitude, and tile bounds', (tester) async {
    final requested = <String>[];

    await tester.pumpWidget(host(OsmTileMap(
      latitude: 120,
      longitude: -540,
      zoom: 30,
      tileUriBuilder: (zoom, x, y) {
        requested.add('$zoom/$x/$y');
        return Uri.parse('https://tiles.test/$zoom/$x/$y.png');
      },
    )));

    expect(requested, isNotEmpty);
    expect(requested.every((tile) => tile.startsWith('19/')), isTrue);
    for (final tile in requested) {
      final parts = tile.split('/').map(int.parse).toList();
      expect(parts[1], inInclusiveRange(0, 524287));
      expect(parts[2], inInclusiveRange(0, 524287));
    }
  });
}
