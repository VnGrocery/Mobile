import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/seller_products/widgets/seller_product_content_editors.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

Widget _host(Widget child) => MaterialApp(
  locale: const Locale('vi'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  group('SellerSpecsEditor', () {
    testWidgets('offers empty rows for a product with no specs', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(SellerSpecsEditor(initial: const [], onChanged: (_) {})),
      );

      expect(
        find.byType(TextField),
        findsNWidgets(SellerSpecsEditor.starterRows * 2),
      );
    });

    testWidgets('pre-fills the rows a product already has', (tester) async {
      await tester.pumpWidget(
        _host(
          SellerSpecsEditor(
            initial: const [SpecItem(key: 'Xuất xứ', value: 'Đà Lạt')],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Xuất xứ'), findsOneWidget);
      expect(find.text('Đà Lạt'), findsOneWidget);
    });

    testWidgets('reports what was typed, trimmed', (tester) async {
      List<SpecItem>? got;
      await tester.pumpWidget(
        _host(SellerSpecsEditor(initial: const [], onChanged: (v) => got = v)),
      );

      await tester.enterText(find.byType(TextField).first, '  Bảo quản  ');
      expect(got!.first.key, 'Bảo quản');
    });

    testWidgets('a removed row is gone from the report', (tester) async {
      List<SpecItem>? got;
      await tester.pumpWidget(
        _host(
          SellerSpecsEditor(
            initial: const [
              SpecItem(key: 'a', value: '1'),
              SpecItem(key: 'b', value: '2'),
              SpecItem(key: 'c', value: '3'),
            ],
            onChanged: (v) => got = v,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();

      expect(got!.map((s) => s.key), ['b', 'c']);
    });
  });

  group('SellerDescriptionEditor', () {
    testWidgets('the template lays out the usual sections', (tester) async {
      List<DescBlock>? got;
      await tester.pumpWidget(
        _host(
          SellerDescriptionEditor(initial: const [], onChanged: (v) => got = v),
        ),
      );

      await tester.tap(find.text('Dùng khung mẫu'));
      await tester.pumpAndSettle();

      expect(got!.where((b) => b.type == DescBlock.heading).length, 4);
      expect(got!.first.text, 'Điểm nổi bật');
    });

    testWidgets('bullets are edited one per line', (tester) async {
      List<DescBlock>? got;
      await tester.pumpWidget(
        _host(
          SellerDescriptionEditor(
            initial: const [DescBlock(type: DescBlock.bullets)],
            onChanged: (v) => got = v,
          ),
        ),
      );

      await tester.enterText(
        find.byType(TextField).first,
        'Hái sáng nay\n   \nKhông thuốc\n',
      );

      // Blank lines are dropped rather than becoming empty bullets.
      expect(got!.first.items, ['Hái sáng nay', 'Không thuốc']);
    });

    testWidgets('an existing bullet block loads as lines', (tester) async {
      await tester.pumpWidget(
        _host(
          SellerDescriptionEditor(
            initial: const [
              DescBlock(type: DescBlock.bullets, items: ['Một', 'Hai']),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Một\nHai'), findsOneWidget);
    });

    testWidgets('blocks can be reordered', (tester) async {
      List<DescBlock>? got;
      await tester.pumpWidget(
        _host(
          SellerDescriptionEditor(
            initial: const [
              DescBlock(type: DescBlock.paragraph, text: 'đầu'),
              DescBlock(type: DescBlock.paragraph, text: 'sau'),
            ],
            onChanged: (v) => got = v,
          ),
        ),
      );

      // The second block's "move up" - the first one's is disabled.
      await tester.tap(find.byIcon(Icons.arrow_upward).last);
      await tester.pump();

      expect(got!.map((b) => b.text), ['sau', 'đầu']);
    });

    testWidgets('warns that freshness claims belong in a pledge', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(SellerDescriptionEditor(initial: const [], onChanged: (_) {})),
      );

      expect(find.textContaining('Ghi nhận'), findsOneWidget);
    });
  });
}
