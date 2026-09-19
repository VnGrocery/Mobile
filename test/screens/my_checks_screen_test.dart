import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
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
};

Future<void> _pump(WidgetTester tester, List<Map<String, Object?>> items) async {
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
  });
}
