import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/engagement/widgets/chain_anchor_badge.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

Engagement _engagement({String status = '', String txHash = ''}) => Engagement(
  targetType: 'product',
  targetId: 'product-1',
  chainTxHash: txHash,
  anchorStatus: status,
);

Future<void> _pump(WidgetTester tester, Engagement engagement) =>
    tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('vi'),
        home: Scaffold(body: ChainAnchorBadge(engagement: engagement)),
      ),
    );

void main() {
  testWidgets('a target nobody has marked promises no write', (tester) async {
    await _pump(tester, _engagement());

    // Nothing has been submitted, so "waiting to be written" would be a
    // claim about a transaction that was never asked for.
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('a tap that is not mined yet reads as waiting', (tester) async {
    await _pump(tester, _engagement(status: 'pending_anchor'));

    final l10n = await AppLocalizations.delegate.load(const Locale('vi'));
    expect(find.text(l10n.engagementAnchorPending), findsOneWidget);
  });

  testWidgets('only a mined tap is called written', (tester) async {
    final l10n = await AppLocalizations.delegate.load(const Locale('vi'));

    await _pump(tester, _engagement(status: 'anchored'));
    // Anchored without a transaction to point at is not proof of anything.
    expect(find.text(l10n.engagementAnchorPending), findsOneWidget);

    await _pump(tester, _engagement(status: 'anchored', txHash: '0xabc'));
    expect(find.text(l10n.engagementAnchored), findsOneWidget);
  });
}
