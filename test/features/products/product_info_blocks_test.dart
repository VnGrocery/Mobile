import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/products/widgets/product_info_blocks.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

Widget _host(Widget child) => MaterialApp(
  locale: const Locale('vi'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

List<SpecItem> _specs(int count) => [
  for (var i = 0; i < count; i++) SpecItem(key: 'Tên $i', value: 'Giá trị $i'),
];

void main() {
  group('ProductSpecsTable', () {
    testWidgets('renders nothing when the seller filled none in', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const ProductSpecsTable(specs: [])));

      // A heading over a blank box would read as a loading failure.
      expect(find.text('Thông tin sản phẩm'), findsNothing);
    });

    testWidgets('shows every row when there are few enough', (tester) async {
      await tester.pumpWidget(_host(ProductSpecsTable(specs: _specs(3))));

      expect(find.text('Giá trị 2'), findsOneWidget);
    });

    testWidgets('hides the overflow until asked', (tester) async {
      await tester.pumpWidget(_host(ProductSpecsTable(specs: _specs(9))));

      expect(find.text('Giá trị 5'), findsOneWidget);
      expect(find.text('Giá trị 8'), findsNothing);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();

      expect(find.text('Giá trị 8'), findsOneWidget);
    });
  });

  group('ProductDescriptionBlocks', () {
    testWidgets('falls back to the flat description of an older product', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const ProductDescriptionBlocks(
            blocks: [],
            fallbackText: 'Rau trồng tại vườn nhà.',
          ),
        ),
      );

      expect(find.text('Rau trồng tại vườn nhà.'), findsOneWidget);
    });

    testWidgets('renders nothing when there is no description at all', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const ProductDescriptionBlocks(blocks: [], fallbackText: '   ')),
      );

      expect(find.text('Mô tả sản phẩm'), findsNothing);
    });

    testWidgets('blocks win over the flat description', (tester) async {
      await tester.pumpWidget(
        _host(
          const ProductDescriptionBlocks(
            blocks: [
              DescBlock(type: DescBlock.heading, text: 'Điểm nổi bật'),
              DescBlock(
                type: DescBlock.bullets,
                items: ['Hái sáng nay', 'Không thuốc'],
              ),
            ],
            fallbackText: 'văn bản cũ',
          ),
        ),
      );

      expect(find.text('Điểm nổi bật'), findsOneWidget);
      expect(find.text('Không thuốc'), findsOneWidget);
      expect(find.text('văn bản cũ'), findsNothing);
    });

    testWidgets('toggles between expanded and collapsed', (tester) async {
      await tester.pumpWidget(
        _host(
          const ProductDescriptionBlocks(
            blocks: [DescBlock(type: DescBlock.paragraph, text: 'Xin chào')],
            fallbackText: '',
          ),
        ),
      );

      expect(find.text('Xem thêm mô tả'), findsOneWidget);

      await tester.tap(find.text('Xem thêm mô tả'));
      await tester.pumpAndSettle();

      expect(find.text('Thu gọn'), findsOneWidget);

      await tester.tap(find.text('Thu gọn'));
      await tester.pumpAndSettle();

      expect(find.text('Xem thêm mô tả'), findsOneWidget);
    });

    testWidgets('skips a block type this build does not know', (tester) async {
      await tester.pumpWidget(
        _host(
          const ProductDescriptionBlocks(
            blocks: [
              DescBlock(type: 'marquee', text: 'không nên hiện'),
              DescBlock(type: DescBlock.paragraph, text: 'nên hiện'),
            ],
            fallbackText: '',
          ),
        ),
      );

      expect(find.text('không nên hiện'), findsNothing);
      expect(find.text('nên hiện'), findsOneWidget);
    });
  });
}
