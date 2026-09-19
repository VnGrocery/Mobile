import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/products/widgets/scanned_lot_card.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/utils/format.dart';

/// The shape `GET /v1/bundles/{bundleId}` returns for a printed label.
Map<String, Object?> _bundleResponse() => {
  'pledgeId': '39a93917-6a7e-4f9e-96d1-fbfa94d73480',
  'bundleId': 'LO-260918-8X1Z7MNE',
  'score': 8.2,
  'category': 'fresh_produce',
  'integrityStatus': 'anchored',
  'committedAt': '2026-09-18T17:42:09.769Z',
};

Future<void> _pump(
  WidgetTester tester,
  PledgeHistoryItem lot, {
  VoidCallback? onRate,
}) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: ScannedLotCard(
            lotCode: 'LO-260918-8X1Z7MNE',
            lot: lot,
            onRate: onRate,
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('ScannedLotCard', () {
    testWidgets('shows the scanned lot score, not the product one', (
      tester,
    ) async {
      // The bug this card exists for: the lot pledged 8.2 while the product
      // page underneath reads 8.7, because that is a later crate. A buyer
      // holding this crate has to be shown 8.2.
      await _pump(tester, PledgeHistoryItem.fromJson(_bundleResponse()));

      expect(find.text('8.2'), findsOneWidget);
      expect(find.text('8.7'), findsNothing);
    });

    testWidgets('shows the lot code and when it was recorded', (tester) async {
      await _pump(tester, PledgeHistoryItem.fromJson(_bundleResponse()));

      expect(find.text('LO-260918-8X1Z7MNE'), findsOneWidget);
      // Computed rather than hardcoded: committedAt is 17:42 UTC, which is
      // already the next day east of Greenwich, so a literal date would pass
      // or fail on where the test runs.
      expect(
        find.textContaining(formatShortDate('2026-09-18T17:42:09.769Z')),
        findsOneWidget,
      );
    });

    testWidgets('offers the rating action next to the score', (tester) async {
      var tapped = false;
      await _pump(
        tester,
        PledgeHistoryItem.fromJson(_bundleResponse()),
        onRate: () => tapped = true,
      );

      // The action further down the page sits a full screen away, which is how
      // a buyer ended up reporting the rating as missing.
      await tester.tap(
        find.byKey(const ValueKey('scanned_lot.rate_freshness')),
      );
      expect(tapped, isTrue);
    });

    testWidgets('hides the action when there is nothing to open', (
      tester,
    ) async {
      await _pump(tester, PledgeHistoryItem.fromJson(_bundleResponse()));

      expect(
        find.byKey(const ValueKey('scanned_lot.rate_freshness')),
        findsNothing,
      );
    });

    testWidgets('renders a pledge that carries no score', (tester) async {
      final json = _bundleResponse()..remove('score');
      await _pump(tester, PledgeHistoryItem.fromJson(json));

      expect(find.text('LO-260918-8X1Z7MNE'), findsOneWidget);
    });
  });
}
