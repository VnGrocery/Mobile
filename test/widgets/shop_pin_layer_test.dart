import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/explore_map/widgets/explore_map_pins.dart';
import 'package:vngrocery/features/explore_map/widgets/shop_pin_layer.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/widgets/map_projection.dart';

const _center = GeoPoint(37.4220, -122.0840);

/// Fits inside flutter_test's default 800x600 surface, so the layer really
/// lays out at this size and the expected projection matches what it used.
const _viewport = Size(400, 400);
const _zoom = 13.0;

Shop _shop(String id, double lat, double lng) => Shop(
  id: id,
  name: 'Shop $id',
  address: 'addr',
  rating: 0,
  reviewCount: 0,
  description: '',
  latitude: lat,
  longitude: lng,
);

const _projection = MapProjection(
  center: _center,
  zoom: _zoom,
  viewport: _viewport,
);

Future<void> _pump(WidgetTester tester, List<Shop> shops) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SizedBox(
          width: _viewport.width,
          height: _viewport.height,
          child: ShopPinLayer(
            shops: shops,
            selectedShopId: null,
            onSelect: (_) {},
            projection: _projection,
            readerAt: _center,
          ),
        ),
      ),
    ),
  );
}

void main() {
  const projection = _projection;

  testWidgets('the tip of the marker sits on the shop coordinate', (
    tester,
  ) async {
    // Due east of the centre: the pin must land level with it, not above it.
    const shopAt = GeoPoint(37.4220, -122.0800);
    await _pump(tester, [_shop('east', shopAt.latitude, shopAt.longitude)]);

    final icon = tester.getRect(find.byIcon(Icons.location_on));
    final expected = projection.project(shopAt);

    expect(icon.center.dx, closeTo(expected.dx, 1));
    // The teardrop points down, so its bottom edge is the anchor.
    expect(icon.bottom, closeTo(expected.dy, 1));
  });

  testWidgets('north is above the centre and south below', (tester) async {
    await _pump(tester, [
      _shop('north', 37.4400, -122.0840),
      _shop('south', 37.4050, -122.0840),
    ]);

    final icons = tester.getRect(find.byIcon(Icons.location_on).first);
    final south = tester.getRect(find.byIcon(Icons.location_on).last);

    expect(icons.bottom, lessThan(_viewport.height / 2));
    expect(south.bottom, greaterThan(_viewport.height / 2));
  });

  testWidgets('a shop with no coordinates gets no pin', (tester) async {
    await _pump(tester, [_shop('nowhere', 0, 0)]);

    expect(find.byType(FloatingShopPin), findsNothing);
  });

  testWidgets('a shop off the edge of the viewport is not drawn', (
    tester,
  ) async {
    await _pump(tester, [_shop('faraway', 40.0, -122.0840)]);

    expect(find.byType(FloatingShopPin), findsNothing);
  });
}
