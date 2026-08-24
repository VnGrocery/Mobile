import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/products/widgets/product_detail_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

Product _product({String description = '', List<String> tags = const []}) =>
    Product(
      id: 'p-1',
      shopId: 'shop-1',
      name: 'Cải ngọt Đà Lạt',
      description: description,
      category: 'fresh_produce',
      freshnessScore: 9.1,
      freshnessNote: '',
      price: 19000,
      tags: tags,
      imageUrls: const [],
      status: 'published',
    );

Future<void> _pump(WidgetTester tester, Product product) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: Scaffold(
        body: SingleChildScrollView(child: ProductTitleBlock(product: product)),
      ),
    ),
  );
}

void main() {
  testWidgets('the buyer sees what the seller wrote about the goods', (
    tester,
  ) async {
    // Collected on the seller's form, stored, written into the signed change
    // log - and for a long time never shown to the one person it was for.
    await _pump(
      tester,
      _product(description: 'Thu hoạch sáng nay, lá còn phấn.'),
    );

    expect(find.text('Thu hoạch sáng nay, lá còn phấn.'), findsOneWidget);
  });

  testWidgets('and the tags the shop list has always shown', (tester) async {
    await _pump(tester, _product(tags: const ['Đà Lạt', 'giao trong ngày']));

    expect(find.text('Đà Lạt'), findsOneWidget);
    expect(find.text('giao trong ngày'), findsOneWidget);
  });

  testWidgets('a listing with neither shows no empty blocks', (tester) async {
    await _pump(tester, _product());

    expect(find.byType(Wrap), findsOneWidget); // only the shop/date meta row
    expect(find.text('Cải ngọt Đà Lạt'), findsOneWidget);
  });

  testWidgets('whitespace is not a description', (tester) async {
    await _pump(tester, _product(description: '   \n  '));

    expect(find.byType(Wrap), findsOneWidget);
  });
}
