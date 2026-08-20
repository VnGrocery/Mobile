import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/buyer_check/widgets/buyer_compare_card.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

BuyerCheckResult _result({
  double pledged = 8.6,
  num actual = 7.4,
  double delta = -1.2,
  bool hasPledge = true,
  bool trusted = false,
  bool categoryMatch = true,
  List<String> reasons = const [],
  double confidence = 0.87,
}) {
  return BuyerCheckResult.fromJson(<String, Object?>{
    'actualScore': actual,
    'locationStatus': 'in_store',
    'verdict': 'mismatch',
    'hasPledge': hasPledge,
    'trusted': trusted,
    'pledgedScore': pledged,
    'scoreDelta': delta,
    'categoryMatch': categoryMatch,
    'actualConfidence': confidence,
    'reasons': reasons,
  });
}

void main() {
  Widget host(Widget child) => MaterialApp(
    locale: const Locale('vi'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('shows pledged and measured scores side by side', (tester) async {
    await tester.pumpWidget(host(BuyerCompareCard(result: _result())));
    await tester.pumpAndSettle();

    expect(find.text('Người bán cam kết'), findsOneWidget);
    expect(find.text('8.6'), findsOneWidget);
    expect(find.text('Đo được lúc này'), findsOneWidget);
    expect(find.text('7.0'), findsOneWidget); // actualScore is rounded to int
    expect(find.text('-1.2'), findsOneWidget);
  });

  testWidgets('marks a check that does not match the pledge', (tester) async {
    await tester.pumpWidget(
      host(BuyerCompareCard(result: _result(trusted: false))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không khớp với cam kết'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber), findsOneWidget);
  });

  testWidgets('marks a check that matches the pledge', (tester) async {
    await tester.pumpWidget(
      host(BuyerCompareCard(result: _result(trusted: true, delta: 0.2))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Khớp với cam kết'), findsOneWidget);
    expect(find.text('+0.2'), findsOneWidget);
  });

  testWidgets('says so when there is no pledge to compare against', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(BuyerCompareCard(result: _result(hasPledge: false, pledged: 0))),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Sản phẩm này chưa có cam kết để đối chiếu.'),
      findsOneWidget,
    );
    expect(find.text('Người bán cam kết'), findsNothing);
  });

  testWidgets('translates reason codes and drops unknown ones', (tester) async {
    await tester.pumpWidget(
      host(
        BuyerCompareCard(
          result: _result(
            reasons: const ['no_pledge', 'a_code_from_a_newer_server'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sản phẩm này chưa có cam kết độ tươi'), findsOneWidget);
    expect(find.textContaining('a_code_from_a_newer_server'), findsNothing);
  });
}
