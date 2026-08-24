import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/widgets/home_product_grid.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

RecommendedProduct _product(String id, String name, {double? distanceKm}) =>
    RecommendedProduct(
      productId: id,
      shopId: 'shop-$id',
      shopName: 'Rau Củ Sạch Bình Thạnh',
      name: name,
      category: 'fresh_produce',
      price: 21000,
      distanceKm: distanceKm,
    );

/// A real phone's width, not the 800dp test default: the cards are half of
/// whatever they are given, and at 800 they are roomy enough to hide the very
/// overflow these tests exist to catch.
Future<void> _pump(
  WidgetTester tester,
  List<RecommendedProduct> products, {
  double textScale = 1.0,
}) async {
  await tester.binding.setSurfaceSize(const Size(411, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          body: SingleChildScrollView(
            child: HomeProductGrid(products: products, personalised: false),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('cards fit their own content, whatever the name is', (
    tester,
  ) async {
    await _pump(tester, [
      _product('1', 'Mồng tơi', distanceKm: 3.0),
      _product('2', 'Nấm hương khô Sa Pa loại một', distanceKm: 3.0),
      _product('3', 'Bí đao xanh', distanceKm: 3.0),
    ]);

    // A fixed childAspectRatio clipped the card's own bottom padding here,
    // welding the distance line to the edge.
    expect(tester.takeException(), isNull);
    expect(find.text('Mồng tơi'), findsOneWidget);
    expect(find.text('Nấm hương khô Sa Pa loại một'), findsOneWidget);
  });

  testWidgets('and still fit at the largest system font size', (tester) async {
    await _pump(tester, [
      _product('1', 'Nấm hương khô Sa Pa loại một', distanceKm: 3.0),
      _product('2', 'Trứng gà thả vườn', distanceKm: 3.0),
    ], textScale: 2.0);

    expect(tester.takeException(), isNull);
  });

  testWidgets('rank order runs left to right down the page', (tester) async {
    await _pump(tester, [
      for (var i = 0; i < 4; i++) _product('$i', 'Sản phẩm $i'),
    ]);

    final first = tester.getTopLeft(find.text('Sản phẩm 0'));
    final second = tester.getTopLeft(find.text('Sản phẩm 1'));
    final third = tester.getTopLeft(find.text('Sản phẩm 2'));

    // Strongest first: 0 and 1 share the top row, 2 starts the next one.
    expect(second.dy, first.dy);
    expect(second.dx, greaterThan(first.dx));
    expect(third.dy, greaterThan(first.dy));
  });

  testWidgets('an empty ranking renders nothing at all', (tester) async {
    await _pump(tester, const []);

    expect(find.byType(Card), findsNothing);
    expect(find.textContaining('Rau'), findsNothing);
  });
}
