import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_products/controllers/seller_create_product_cubit.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

Product _existing({String status = 'published'}) => Product(
  id: 'p-1',
  shopId: 'shop-1',
  name: 'Cải ngọt Đà Lạt',
  description: 'Thu hoạch sáng nay',
  category: 'fresh_produce',
  freshnessScore: 9.1,
  freshnessNote: 'Hàng tuyển loại 1',
  price: 18000,
  tags: const ['Đà Lạt'],
  imageUrls: const ['https://example.test/a.png'],
  status: status,
  version: 4,
);

/// Captures what the app actually sent, and answers with it echoed back.
({AppRepositories repositories, List<http.Request> sent}) _capturing() {
  final sent = <http.Request>[];
  final repositories = AppRepositories.forTesting(
    MockDb.instance,
    RemoteDataSource(
      ApiClient(
        baseUrl: 'http://localhost:5050',
        tokenReader: () => 'token',
        client: MockClient((request) async {
          sent.add(request);
          final body = request.body.isEmpty
              ? <String, Object?>{}
              : jsonDecode(request.body) as Map<String, Object?>;
          return http.Response.bytes(
            utf8.encode(
              jsonEncode({
                'productId': body['productId'] ?? 'p-1',
                'shopId': 'shop-1',
                'name': body['name'] ?? 'Cải ngọt Đà Lạt',
                'description': body['description'] ?? '',
                'category': body['category'] ?? 'fresh_produce',
                'freshnessScore': body['freshnessScore'] ?? 9.1,
                'freshnessNote': body['freshnessNote'] ?? '',
                'price': body['price'] ?? 18000,
                'tags': body['tags'] ?? <String>[],
                'imageUrls': body['imageUrls'] ?? <String>[],
                'status': body['status'] ?? 'published',
                'version': 5,
              }),
            ),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }),
      ),
    ),
  );
  return (repositories: repositories, sent: sent);
}

Future<AppLocalizations> _l10n(WidgetTester tester) async {
  late AppLocalizations l10n;
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('vi'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          l10n = AppLocalizations.of(context);
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return l10n;
}

void main() {
  tearDown(MockDb.instance.resetForTesting);

  testWidgets('an edit is a PUT carrying the reason and the version', (
    tester,
  ) async {
    final l10n = await _l10n(tester);
    final capture = _capturing();
    final cubit = SellerCreateProductCubit(
      shopId: 'shop-1',
      existing: _existing(),
      repositories: capture.repositories,
    );

    await cubit.save(
      name: 'Cải ngọt Đà Lạt',
      description: 'Thu hoạch sáng nay',
      price: '19.000 đ',
      tags: 'Đà Lạt',
      l10n: l10n,
      changeReason: 'Giá chợ đầu mối tăng sáng nay',
    );

    final request = capture.sent.single;
    // PUT, not POST: an edit that creates a second listing is not an edit.
    expect(request.method, 'PUT');
    expect(request.url.path, '/v1/shops/shop-1/products/p-1');

    final body = jsonDecode(request.body) as Map<String, Object?>;
    // The reason rides inside the signed envelope; without it the server
    // refuses the change outright.
    expect(body['changeReason'], 'Giá chợ đầu mối tăng sáng nay');
    // The version is what lets the server reject an edit written against a
    // copy someone else has already moved on.
    expect(body['expectedVersion'], 4);
    expect(body['price'], 19000);
    expect(body['productId'], 'p-1');

    cubit.close();
  });

  testWidgets('editing keeps the status the seller put the listing in', (
    tester,
  ) async {
    final l10n = await _l10n(tester);
    final capture = _capturing();
    final cubit = SellerCreateProductCubit(
      shopId: 'shop-1',
      existing: _existing(status: 'draft'),
      repositories: capture.repositories,
    );

    await cubit.save(
      name: 'Cải ngọt Đà Lạt',
      description: '',
      price: '19.000 đ',
      tags: '',
      l10n: l10n,
      changeReason: 'Sửa lại mô tả',
    );

    final body = jsonDecode(capture.sent.single.body) as Map<String, Object?>;
    // Correcting a description must not quietly put a draft on sale.
    expect(body['status'], 'draft');

    cubit.close();
  });

  testWidgets('a listing keeps its photo when none is re-taken', (
    tester,
  ) async {
    final l10n = await _l10n(tester);
    final capture = _capturing();
    final cubit = SellerCreateProductCubit(
      shopId: 'shop-1',
      existing: _existing(),
      repositories: capture.repositories,
    );

    await cubit.save(
      name: 'Cải ngọt Đà Lạt',
      description: '',
      price: '18.000 đ',
      tags: '',
      l10n: l10n,
      changeReason: 'Sửa lại mô tả',
    );

    final body = jsonDecode(capture.sent.single.body) as Map<String, Object?>;
    expect(body['imageUrls'], ['https://example.test/a.png']);

    cubit.close();
  });

  test(
    'deleting sends the reason and the version the server asked for',
    () async {
      final capture = _capturing();

      await capture.repositories.products.deleteRemote(
        _existing(),
        'Đăng nhầm sản phẩm',
      );

      final request = capture.sent.single;
      expect(request.method, 'DELETE');
      expect(request.url.queryParameters['changeReason'], 'Đăng nhầm sản phẩm');
      expect(request.url.queryParameters['expectedVersion'], '4');
    },
  );

  test('a new listing is still a POST with no reason to give', () async {
    final capture = _capturing();

    await capture.repositories.products.saveRemote(_existing());

    expect(capture.sent.single.method, 'POST');
  });
}
