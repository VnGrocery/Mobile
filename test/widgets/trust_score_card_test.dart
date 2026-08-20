import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/widgets/trust_score_card.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

TrustSummary _summary({
  double score = 81.4,
  String grade = 'good',
  bool hasPledges = true,
  int pledgeCount = 1,
  int buyerCheckCount = 0,
  List<String> reasons = const ['no_customer_reviews'],
}) {
  return TrustSummary.fromJson(<String, Object?>{
    'hasPledges': hasPledges,
    'pledgeCount': pledgeCount,
    'buyerCheckCount': buyerCheckCount,
    'score': score,
    'grade': grade,
    'formulaVersion': 'trust_score_v2',
    'pledgeScore': 87.8,
    'reviewScore': 50,
    'buyerCheckScore': 50,
    'consistencyScore': 70,
    'recencyScore': 100,
    'coverageScore': 40,
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

  testWidgets('shows score, grade and every sub-score', (tester) async {
    await tester.pumpWidget(host(TrustScoreCard(summary: _summary())));
    await tester.pumpAndSettle();

    expect(find.text('81'), findsOneWidget);
    expect(find.text('Tốt'), findsOneWidget);

    // All six components are named.
    expect(find.text('Cam kết người bán'), findsOneWidget);
    expect(find.text('Đánh giá khách hàng'), findsOneWidget);
    expect(find.text('Kiểm chứng người mua'), findsOneWidget);
    expect(find.text('Tính nhất quán'), findsOneWidget);
    expect(find.text('Hoạt động gần đây'), findsOneWidget);
    expect(find.text('Độ phủ dữ liệu'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNWidgets(6));
  });

  testWidgets('shows translated reasons, never raw codes', (tester) async {
    await tester.pumpWidget(
      host(
        TrustScoreCard(
          summary: _summary(
            reasons: const ['no_buyer_checks', 'a_code_from_a_newer_server'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có người mua nào kiểm chứng'), findsOneWidget);
    expect(find.textContaining('a_code_from_a_newer_server'), findsNothing);
  });

  testWidgets('says there is no data rather than scoring a new shop zero', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        TrustScoreCard(
          summary: _summary(
            score: 0,
            grade: 'risk',
            hasPledges: false,
            pledgeCount: 0,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Chưa đủ dữ liệu để đánh giá cửa hàng này.'),
      findsOneWidget,
    );
    // A shop with no signal must not be labelled risky.
    expect(find.text('Rủi ro'), findsNothing);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('grade chip hides itself when there is no data', (tester) async {
    await tester.pumpWidget(
      host(
        TrustGradeChip(summary: _summary(hasPledges: false, pledgeCount: 0)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Row), findsNothing);
  });

  testWidgets('grade chip shows score and grade when there is data', (
    tester,
  ) async {
    await tester.pumpWidget(host(TrustGradeChip(summary: _summary())));
    await tester.pumpAndSettle();

    expect(find.text('81 · Tốt'), findsOneWidget);
  });
}
