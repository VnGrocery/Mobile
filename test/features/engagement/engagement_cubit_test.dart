import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/engagement/controllers/engagement_cubit.dart';

Map<String, Object?> _state({
  int follows = 0,
  int likes = 0,
  int loves = 0,
  List<String> mine = const [],
  String txHash = '',
  String status = '',
}) => {
  'targetType': 'product',
  'targetId': 'product-1',
  'follows': follows,
  'likes': likes,
  'loves': loves,
  'mine': mine,
  'chainTxHash': txHash,
  'anchorStatus': status,
  if (status == 'anchored') 'chainAnchorTime': '2026-03-01T09:00:00Z',
};

http.Response _json(Object body, [int code = 200]) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  code,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

EngagementCubit _cubit(MockClient client, {String targetType = 'product'}) =>
    EngagementCubit(
      targetType: targetType,
      targetId: 'product-1',
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
  test('the totals and the reader\'s own marks arrive together', () async {
    final cubit = _cubit(
      MockClient(
        (_) async => _json(
          _state(
            likes: 7,
            loves: 3,
            mine: ['love'],
            status: 'anchored',
            txHash: '0xabc',
          ),
        ),
      ),
    );

    await cubit.load();

    final data = cubit.state.data!;
    expect(data.likes, 7);
    expect(data.loves, 3);
    // Without this the heart would draw hollow on a product this reader has
    // already loved, and a second tap would take the love away by surprise.
    expect(data.loved, isTrue);
    expect(data.liked, isFalse);
    expect(data.anchored, isTrue);
  });

  test('an anchor still waiting for its block is not called proven', () async {
    final cubit = _cubit(
      MockClient((_) async => _json(_state(loves: 1, status: 'pending'))),
    );

    await cubit.load();

    expect(cubit.state.data!.anchored, isFalse);
  });

  test('a tx hash with no anchored status is not enough either', () async {
    final cubit = _cubit(
      MockClient(
        (_) async =>
            _json(_state(loves: 1, txHash: '0xabc', status: 'pending')),
      ),
    );

    await cubit.load();

    expect(cubit.state.data!.anchored, isFalse);
  });

  test(
    'the total comes back from the server rather than being counted up here',
    () async {
      var toggles = 0;
      final cubit = _cubit(
        MockClient((request) async {
          if (request.method == 'POST') {
            toggles++;
            expect(jsonDecode(request.body), {
              'targetType': 'product',
              'targetId': 'product-1',
              'kind': 'love',
            });
            // Someone else loved it in the same moment, so the figure jumps by
            // two. A local increment would have shown one.
            return _json(_state(loves: 12, mine: ['love']));
          }
          return _json(_state(loves: 10));
        }),
      );

      await cubit.load();
      expect(cubit.state.data!.loves, 10);

      await cubit.toggle('love');

      expect(toggles, 1);
      expect(cubit.state.data!.loves, 12);
      expect(cubit.state.data!.loved, isTrue);
      expect(cubit.state.pending, isNull);
    },
  );

  test(
    'a refused tap rethrows and leaves the last known figure alone',
    () async {
      final cubit = _cubit(
        MockClient((request) async {
          if (request.method == 'POST') return _json({'error': 'nope'}, 500);
          return _json(_state(loves: 4, mine: ['love']));
        }),
      );

      await cubit.load();

      await expectLater(cubit.toggle('love'), throwsA(anything));

      // Still four, still loved: the screen must not show the tap as having
      // landed when the server never took it.
      expect(cubit.state.data!.loves, 4);
      expect(cubit.state.data!.loved, isTrue);
      expect(cubit.state.pending, isNull);
    },
  );

  test(
    'an unreachable server is reported, not shown as zero reactions',
    () async {
      final cubit = _cubit(MockClient((_) async => http.Response('nope', 500)));

      await cubit.load();

      expect(cubit.state.failed, isTrue);
      expect(cubit.state.data, isNull);
    },
  );

  test('a shop reads its follower count from the same endpoint', () async {
    final cubit = _cubit(
      MockClient((request) async {
        expect(request.url.query, contains('targetType=shop'));
        return _json({
          'targetType': 'shop',
          'targetId': 'product-1',
          'follows': 21,
          'likes': 0,
          'loves': 0,
          'mine': ['follow'],
          'anchorStatus': 'anchored',
          'chainTxHash': '0xfeed',
        });
      }),
      targetType: 'shop',
    );

    await cubit.load();

    expect(cubit.state.data!.follows, 21);
    expect(cubit.state.data!.following, isTrue);
  });
}
