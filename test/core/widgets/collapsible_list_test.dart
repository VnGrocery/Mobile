import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/widgets/collapsible_list.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

Widget _host(int itemCount, {int collapsedCount = 5}) => MaterialApp(
  locale: const Locale('vi'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: SingleChildScrollView(
      child: CollapsibleList(
        itemCount: itemCount,
        collapsedCount: collapsedCount,
        itemBuilder: (context, index, isLast) =>
            Text('mục $index${isLast ? ' (cuối)' : ''}'),
      ),
    ),
  ),
);

void main() {
  testWidgets('shows only the most recent few and hides the rest', (
    tester,
  ) async {
    await tester.pumpWidget(_host(12));

    expect(find.text('mục 0'), findsOneWidget);
    expect(find.text('mục 4 (cuối)'), findsOneWidget);
    expect(find.text('mục 5'), findsNothing);
    expect(find.text('Xem thêm 7 mục'), findsOneWidget);
  });

  testWidgets('the arrow opens the full list and closes it again', (
    tester,
  ) async {
    await tester.pumpWidget(_host(12));

    await tester.tap(find.text('Xem thêm 7 mục'));
    await tester.pumpAndSettle();

    expect(find.text('mục 11 (cuối)'), findsOneWidget);
    expect(find.text('Thu gọn'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);

    await tester.tap(find.text('Thu gọn'));
    await tester.pumpAndSettle();

    expect(find.text('mục 5'), findsNothing);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
  });

  testWidgets('a short list has no toggle at all', (tester) async {
    await tester.pumpWidget(_host(3));

    expect(find.text('mục 2 (cuối)'), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('the last entry shown is the one told it is last', (
    tester,
  ) async {
    // The change log draws its connecting line from this, so a collapsed list
    // must not leave a line running into the toggle.
    await tester.pumpWidget(_host(12));

    expect(find.text('mục 11 (cuối)'), findsNothing);
    expect(find.text('mục 4 (cuối)'), findsOneWidget);
  });
}
