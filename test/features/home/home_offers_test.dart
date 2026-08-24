import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';

RemoteDataSource _remote(MockClient client) => RemoteDataSource(
  ApiClient(
    baseUrl: 'http://localhost:5050',
    tokenReader: () => 'token',
    client: client,
  ),
);

http.Response _json(Object body) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  200,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

void main() {
  test('an offer carries the shop it can be redeemed at', () async {
    Uri? asked;
    final offers = await _remote(
      MockClient((request) async {
        asked = request.url;
        return _json({
          'items': [
            {
              'voucherId': 'v-1',
              'code': 'RAUSACH10',
              'title': 'Giảm 10% đơn rau củ',
              'shopId': 'shop-1',
              'shopName': 'Rau Sạch Cô Ba',
              'discountValue': 10,
              'isPercent': true,
              'minSpend': 100000,
              'expiresAt': '2026-10-04T15:53:08Z',
            },
          ],
        });
      }),
    ).featuredVouchers();

    expect(asked?.path, '/v1/vouchers');
    final offer = offers.single;
    // A discount at an unnamed stall is not something a reader can act on.
    expect(offer.shopName, 'Rau Sạch Cô Ba');
    expect(offer.voucher.isPercent, isTrue);
    expect(offer.voucher.minSpend, 100000);
  });

  test('no live offers means an empty slot, not a placeholder', () async {
    final offers = await _remote(
      MockClient((_) async => _json({'items': <Object>[]})),
    ).featuredVouchers();

    expect(offers, isEmpty);
  });

  test('a check reads back with the names behind its ids', () async {
    Uri? asked;
    final checks = await _remote(
      MockClient((request) async {
        asked = request.url;
        return _json({
          'items': [
            {
              'checkId': 'chk-1',
              'shopId': 'shop-1',
              'productId': 'p-1',
              'productName': 'Cải ngọt Đà Lạt',
              'shopName': 'Rau Sạch Cô Ba',
              'verdict': 'trusted',
              'hasPledge': true,
              'pledgedScore': 9.1,
              'actualScore': 8.8,
              'createdAt': '2026-08-24T03:15:00Z',
            },
          ],
        });
      }),
    ).myChecks();

    expect(asked?.path, '/v1/me/checks');
    final check = checks.single;
    expect(check.productName, 'Cải ngọt Đà Lạt');
    expect(check.shopName, 'Rau Sạch Cô Ba');
    expect(check.hasPledge, isTrue);
    expect(check.actualScore, 8.8);
  });

  test(
    'a check with no pledge says so rather than comparing to zero',
    () async {
      final checks = await _remote(
        MockClient(
          (_) async => _json({
            'items': [
              {
                'checkId': 'chk-2',
                'shopId': 'shop-1',
                'productId': 'p-1',
                'verdict': 'no_pledge',
                'hasPledge': false,
                'createdAt': '2026-08-24T03:15:00Z',
              },
            ],
          }),
        ),
      ).myChecks();

      expect(checks.single.hasPledge, isFalse);
      expect(checks.single.productName, isEmpty);
    },
  );
}
