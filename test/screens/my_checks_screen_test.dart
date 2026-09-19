import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/account/controllers/session_state.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/screens/my_checks_screen.dart';

/// One row of `GET /v1/me/checks`, in the shape the Go DTO writes it.
Map<String, Object?> _check({
  required String status,
  required String verdict,
  String imageUrl = 'https://ipfs.example/ipfs/bafy-photo',
}) => {
  'checkId': '1e2d3c4b-0000-4000-8000-000000000001',
  'shopId': 'shop-1',
  'productId': 'product-1',
  'productName': 'Cà chua beef',
  'shopName': 'Rau Hữu Cơ Quận 3',
  'status': status,
  'verdict': verdict,
  'hasPledge': true,
  'pledgedScore': 8.5,
  'actualScore': verdict == 'pending' ? 0 : 8.2,
  'imageUrl': imageUrl,
  'createdAt': '2026-09-18T17:42:09.769Z',
  'bundleId': 'LO-260918-8X1Z7MNE',
  'scoreDelta': verdict == 'pending' ? 0 : -0.3,
  'categoryMatch': verdict != 'pending',
  'actualConfidence': verdict == 'pending' ? 0 : 0.88,
  'locationStatus': 'verified_near_shop',
  'trusted': verdict == 'trusted',
  'reasons': verdict == 'pending'
      ? const ['awaiting_ai_review']
      : const <String>[],
};

Future<void> _pump(
  WidgetTester tester,
  List<Map<String, Object?>> items,
) async {
  AppRepositories.configureRemote(
    RemoteDataSource(
      ApiClient(
        baseUrl: 'http://localhost:5050',
        tokenReader: () => 'token',
        client: MockClient((request) async {
          if (!request.url.path.endsWith('/me/checks')) {
            return http.Response('{}', 404);
          }
          return http.Response.bytes(
            utf8.encode(jsonEncode({'items': items})),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }),
      ),
    ),
  );

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: const MyChecksScreen(),
      // The real route table, so a tap is routed the way the app routes it
      // rather than the way the test wishes it would.
      onGenerateRoute: (settings) => Routes.onGenerateRoute(
        settings,
        session: const SessionState(
          token: 'token',
          shopId: null,
          email: 'buyer@vngrocery.demo',
          displayName: 'Buyer',
          role: 'buyer',
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('MyChecksScreen', () {
    testWidgets('a scored check shows its photo and the AI verdict', (
      tester,
    ) async {
      await _pump(tester, [_check(status: 'completed', verdict: 'trusted')]);

      expect(find.byKey(const ValueKey('my_check.photo')), findsOneWidget);
      expect(find.text('Đang chờ duyệt'), findsNothing);
      // The scored path still reads exactly as it did before.
      expect(find.textContaining('Đo được'), findsOneWidget);
    });

    testWidgets('an unscored check reads as pending, not as a verdict', (
      tester,
    ) async {
      await _pump(tester, [
        _check(status: 'pending_review', verdict: 'pending'),
      ]);

      // The photo is the point of keeping the row at all.
      expect(find.byKey(const ValueKey('my_check.photo')), findsOneWidget);
      expect(find.text('Đang chờ duyệt'), findsOneWidget);
      // No score comparison, because nothing measured anything. Printing
      // "Đo được 0" would be the AI claiming the goods scored zero.
      expect(find.textContaining('Đo được'), findsNothing);
    });

    testWidgets('a check whose upload failed still lists', (tester) async {
      await _pump(tester, [
        _check(status: 'pending_review', verdict: 'pending', imageUrl: ''),
      ]);

      expect(find.byKey(const ValueKey('my_check.photo')), findsNothing);
      expect(find.text('Cà chua beef'), findsOneWidget);
    });

    testWidgets('tapping a row opens the check, not the product', (
      tester,
    ) async {
      await _pump(tester, [_check(status: 'completed', verdict: 'trusted')]);

      await tester.tap(find.byKey(const ValueKey('my_check.badge')));
      // Pumped by hand rather than settled: the photo placeholder is a
      // CircularProgressIndicator, which never stops animating, so
      // pumpAndSettle waits for a frame that never comes.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byKey(const ValueKey('my_check_detail.screen')), findsOne);
      // The scores the row had no space for, and the reason they differ.
      expect(find.text('8.5'), findsOneWidget);
      expect(find.text('8.2'), findsOneWidget);
      // The product is a button away rather than the whole destination. It
      // sits below the fold, so the list has to be scrolled to build it.
      // The list underneath is still mounted, so the drag has to name the
      // detail screen's own list.
      await tester.drag(
        find.descendant(
          of: find.byKey(const ValueKey('my_check_detail.screen')),
          matching: find.byType(ListView),
        ),
        const Offset(0, -400),
      );
      await tester.pump();
      expect(
        find.byKey(const ValueKey('my_check_detail.view_product')),
        findsOneWidget,
      );
    });

    testWidgets('the detail of an unscored check shows no measurement', (
      tester,
    ) async {
      await _pump(tester, [
        _check(status: 'pending_review', verdict: 'pending'),
      ]);

      await tester.tap(find.byKey(const ValueKey('my_check.badge')));
      // Pumped by hand rather than settled: the photo placeholder is a
      // CircularProgressIndicator, which never stops animating, so
      // pumpAndSettle waits for a frame that never comes.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byKey(const ValueKey('my_check_detail.pending')), findsOne);
      // No compare card, because there is nothing to compare: printing
      // "Đo được 0.0" would be a measurement nothing took.
      expect(find.text('Đo được lúc này'), findsNothing);
      expect(find.text('LO-260918-8X1Z7MNE'), findsOneWidget);
    });
  });
}
