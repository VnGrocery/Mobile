import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/widgets/collapsible_list.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

Future<void> _pump(WidgetTester tester, int count) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: CollapsibleList(
            itemCount: count,
            itemBuilder: (context, index, isLast) => Text('mục $index'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('a short list shows everything and offers no toggle', (
    tester,
  ) async {
    await _pump(tester, 3);

    expect(find.text('mục 2'), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('a long list stops at five and names what is hidden', (
    tester,
  ) async {
    await _pump(tester, 7);

    expect(find.text('mục 4'), findsOneWidget);
    expect(find.text('mục 5'), findsNothing);
    // The count belongs in the label: "more" alone does not say whether it is
    // worth the tap.
    expect(find.text('Xem thêm 2 mục'), findsOneWidget);

    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    expect(find.text('mục 6'), findsOneWidget);
    expect(find.text('Thu gọn'), findsOneWidget);
  });
}
