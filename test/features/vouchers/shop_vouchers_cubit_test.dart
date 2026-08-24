import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/core/network/api_exception.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/vouchers/controllers/shop_vouchers_cubit.dart';

Map<String, Object?> _offer({
  String id = 'v-1',
  int total = 0,
  int claimed = 0,
  bool active = true,
  String expires = '2027-01-01T00:00:00Z',
}) {
  final limited = total > 0;
  final remaining = limited ? (total - claimed).clamp(0, total) : 0;
  return {
    'voucherId': id,
    'shopId': 'shop-1',
    'code': 'RAUSACH10',
    'title': 'Giảm 10% đơn rau củ',
    'discountValue': 10,
    'isPercent': true,
    'minSpend': 100000,
    'expiresAt': expires,
    'active': active,
    'totalQuantity': total,
    'claimedCount': claimed,
    'remaining': remaining,
    'limited': limited,
    'soldOut': limited && remaining == 0,
  };
}

http.Response _json(Object body, [int code = 200]) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  code,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

ShopVouchersCubit _cubit(MockClient client) => ShopVouchersCubit(
  shopId: 'shop-1',
  repositories: AppRepositories.forTesting(
    MockDb.instance,
    RemoteDataSource(
      ApiClient(
        baseUrl: 'http://localhost:5050',
        tokenReader: () => 'token',
        client: client,
      ),
    ),
  ),
);

void main() {
  tearDown(MockDb.instance.resetForTesting);

  test('an offer already in the wallet is marked claimed', () async {
    final cubit = _cubit(
      MockClient((request) async {
        if (request.url.path == '/v1/me/vouchers') {
          return _json({
            'items': [
              {
                'userVoucherId': 'uv-1',
                'voucherId': 'v-1',
                'used': false,
                'voucher': _offer(),
              },
            ],
          });
        }
        return _json({
          'items': [_offer(), _offer(id: 'v-2')],
        });
      }),
    );

    await cubit.load();

    // Without the wallet the card would invite a claim that does nothing.
    expect(cubit.state.claimed, {'v-1'});
    expect(cubit.state.offers.length, 2);
    expect(cubit.state.failed, isFalse);
  });

  test('a sold-out offer arrives marked, not silently claimable', () async {
    final cubit = _cubit(
      MockClient((request) async {
        if (request.url.path == '/v1/me/vouchers') {
          return _json({'items': <Object>[]});
        }
        return _json({
          'items': [_offer(total: 50, claimed: 50)],
        });
      }),
    );

    await cubit.load();

    final offer = cubit.state.offers.single;
    expect(offer.soldOut, isTrue);
    expect(offer.remaining, 0);
    expect(offer.isClaimable, isFalse);
  });

  test('an expired offer is not claimable however the counts read', () async {
    final cubit = _cubit(
      MockClient((request) async {
        if (request.url.path == '/v1/me/vouchers') {
          return _json({'items': <Object>[]});
        }
        return _json({
          'items': [_offer(expires: '2020-01-01T00:00:00Z')],
        });
      }),
    );

    await cubit.load();

    expect(cubit.state.offers.single.isClaimable, isFalse);
  });

  test(
    'claiming re-reads the shop rather than counting down locally',
    () async {
      var claims = 0;
      var lists = 0;
      final cubit = _cubit(
        MockClient((request) async {
          if (request.method == 'POST') {
            claims++;
            return _json({
              'userVoucherId': 'uv-1',
              'voucherId': 'v-1',
              'used': false,
              'voucher': _offer(total: 50, claimed: 41),
            }, 201);
          }
          if (request.url.path == '/v1/me/vouchers') {
            return _json({
              'items': claims == 0
                  ? <Object>[]
                  : [
                      {
                        'userVoucherId': 'uv-1',
                        'voucherId': 'v-1',
                        'used': false,
                        'voucher': _offer(total: 50, claimed: 41),
                      },
                    ],
            });
          }
          lists++;
          return _json({
            'items': [_offer(total: 50, claimed: claims == 0 ? 40 : 41)],
          });
        }),
      );

      await cubit.load();
      expect(cubit.state.offers.single.remaining, 10);

      await cubit.claim(cubit.state.offers.single);

      // Someone else may have taken one in the meantime, so the count comes
      // back from the server rather than being decremented here.
      expect(claims, 1);
      expect(lists, 2);
      expect(cubit.state.offers.single.remaining, 9);
      expect(cubit.state.claimed, {'v-1'});
      expect(cubit.state.claiming, isNull);
    },
  );

  test('an offer that ran out mid-screen surfaces the 409', () async {
    final cubit = _cubit(
      MockClient((request) async {
        if (request.method == 'POST') {
          return _json({'error': 'voucher has been fully claimed'}, 409);
        }
        if (request.url.path == '/v1/me/vouchers') {
          return _json({'items': <Object>[]});
        }
        return _json({
          'items': [_offer(total: 1, claimed: 0)],
        });
      }),
    );
    await cubit.load();

    // The screen tells the reader the shop ran out, which is a different
    // thing from a connection that dropped.
    await expectLater(
      cubit.claim(cubit.state.offers.single),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 409),
      ),
    );
    expect(cubit.state.claiming, isNull);
  });

  test('an unreachable shop is not reported as running no offers', () async {
    final cubit = _cubit(MockClient((_) async => http.Response('nope', 500)));

    await cubit.load();

    expect(cubit.state.failed, isTrue);
    expect(cubit.state.isEmpty, isTrue);
  });
}
