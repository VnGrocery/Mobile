import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/widgets/trust_badge.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

PledgeProof _proof({
  required String status,
  List<String> actions = const [],
  String summary = '',
}) {
  return PledgeProof.fromJson(<String, Object?>{
    'pledgeId': 'p1',
    'shopId': 's1',
    'committedAt': '2026-08-20T10:00:00Z',
    'proofStatus': status,
    'proofSummary': summary,
    'recommendedActions': actions,
  });
}

void main() {
  Widget host(Widget child, {Locale locale = const Locale('vi')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets('shows the verified label', (tester) async {
    await tester.pumpWidget(
      host(
        TrustBadge(
          proof: _proof(status: 'verified', actions: ['show_verified_badge']),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đã xác thực on-chain'), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsOneWidget);
  });

  testWidgets('shows the pending label', (tester) async {
    await tester.pumpWidget(
      host(
        TrustBadge(
          proof: _proof(
            status: 'pending',
            actions: ['show_pending_badge', 'retry_later'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đang neo lên blockchain'), findsOneWidget);
  });

  testWidgets('hides itself when the server says hide_trust_badge', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        TrustBadge(
          proof: _proof(
            status: 'revoked',
            actions: ['hide_trust_badge', 'show_revoked_state'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The server's directive wins over the app's own idea of what to show.
    expect(find.byType(Row), findsNothing);
    expect(find.text('Cam kết đã bị thu hồi'), findsNothing);
  });

  testWidgets('ignoreHideAction renders the revoked state anyway', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        TrustBadge(
          proof: _proof(status: 'revoked', actions: ['hide_trust_badge']),
          ignoreHideAction: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cam kết đã bị thu hồi'), findsOneWidget);
  });

  testWidgets('translates rather than echoing the server copy', (tester) async {
    await tester.pumpWidget(
      host(
        TrustBadge(
          proof: _proof(
            status: 'verified',
            summary: 'Cam ket da duoc xac thuc',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Accented app copy, not the server's unaccented string.
    expect(find.text('Đã xác thực on-chain'), findsOneWidget);
  });

  testWidgets('uses English copy under an English locale', (tester) async {
    await tester.pumpWidget(
      host(
        TrustBadge(proof: _proof(status: 'verified')),
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Verified on blockchain'), findsOneWidget);
  });

  testWidgets('is tappable when given a callback', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      host(
        TrustBadge(
          proof: _proof(status: 'verified'),
          onTap: () => taps++,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TrustBadge));
    expect(taps, 1);
  });
}
