import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/widgets/trust_copy.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

/// Every reason code the server can emit, taken from
/// server/internal/service/shop/service.go.
const _serverReasonCodes = <String>[
  'partial_trust_data',
  'no_customer_reviews',
  'no_buyer_checks',
  'no_eligible_buyer_checks',
  'buyer_checks_confirmed',
  'buyer_checks_high_risk',
  'buyer_checks_show_consistency_issues',
  'duplicate_buyer_checks_discounted',
  'pledges_consistent_with_buyer_checks',
  'limited_consistency_data',
  'no_consistency_signals',
  'limited_signal_coverage',
  'recent_activity_available',
  'no_recent_activity',
  'no_pledge',
  'no_seller_pledges',
  'some_pledges_low_confidence',
];

void main() {
  late BuildContext ctx;

  Future<void> pump(WidgetTester tester, {Locale locale = const Locale('vi')}) {
    return tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox();
          },
        ),
      ),
    );
  }

  testWidgets('translates every reason code the server can send', (
    tester,
  ) async {
    await pump(tester);

    for (final code in _serverReasonCodes) {
      final text = TrustCopy.reason(ctx, code);
      expect(text, isNotNull, reason: 'missing translation for $code');
      expect(text, isNot(contains('_')), reason: '$code leaked a raw code');
    }
  });

  testWidgets('drops codes it does not recognise instead of showing them', (
    tester,
  ) async {
    await pump(tester);

    expect(TrustCopy.reason(ctx, 'a_brand_new_code'), isNull);
    expect(
      TrustCopy.reasons(ctx, ['no_buyer_checks', 'a_brand_new_code']),
      hasLength(1),
    );
  });

  testWidgets('names every grade', (tester) async {
    await pump(tester);

    for (final grade in TrustGrade.values) {
      expect(TrustCopy.grade(ctx, grade), isNotEmpty);
    }
    expect(TrustCopy.grade(ctx, TrustGrade.excellent), 'Rất tốt');
  });

  testWidgets('names every sub-score component', (tester) async {
    await pump(tester);

    const summary = TrustSummary();
    for (final component in summary.components) {
      final name = TrustCopy.component(ctx, component.key);
      expect(name, isNotEmpty);
      expect(name, isNot(component.key));
    }
  });

  testWidgets('uses English copy under an English locale', (tester) async {
    await pump(tester, locale: const Locale('en'));

    expect(TrustCopy.grade(ctx, TrustGrade.excellent), 'Excellent');
    expect(TrustCopy.reason(ctx, 'no_buyer_checks'), contains('buyer'));
  });
}
