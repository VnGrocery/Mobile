import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/activity/controllers/activity_cubit.dart';

Map<String, Object?> _event(
  String id, {
  String action = 'engagement.added',
  String status = 'follow',
  int sequence = 1,
}) => {
  'eventId': id,
  'action': action,
  'status': status,
  'resourceType': 'engagement',
  'resourceId': 'shop:shop-1',
  'sequence': sequence,
  'contentSha256': 'czLGMHBJQjpTDnUUmb0nTZY7Ie4P9Y3ca0MaI2cK1oU=',
  'signature': 'Jp6bFfL+ZVt',
  'createdAt': '2026-04-07T02:00:00Z',
};

http.Response _json(Object body, [int code = 200]) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  code,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

ActivityCubit _cubit(MockClient client) => ActivityCubit(
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
  test('the trail is asked for without naming an actor', () async {
    var asked = '';
    final cubit = _cubit(
      MockClient((request) async {
        asked = request.url.toString();
        return _json({
          'items': [_event('event-1')],
        });
      }),
    );

    await cubit.load();

    // The session decides whose trail this is. Sending an id would invite a
    // client to ask for somebody else's.
    expect(asked, isNot(contains('actorUserId')));
    expect(cubit.state.events.single.eventId, 'event-1');
    expect(cubit.state.failed, isFalse);
  });

  test('a short page means the trail has ended', () async {
    final cubit = _cubit(
      MockClient(
        (_) async => _json({
          'items': [_event('event-1'), _event('event-2', sequence: 2)],
        }),
      ),
    );

    await cubit.load();

    expect(cubit.state.hasMore, isFalse);
  });

  test('scrolling past the first page appends rather than replaces', () async {
    var page = 0;
    final cubit = _cubit(
      MockClient((request) async {
        page = int.parse(request.url.queryParameters['page']!);
        return _json({
          'items': List.generate(
            ActivityCubit.pageSize,
            (index) => _event('event-$page-$index', sequence: index + 1),
          ),
        });
      }),
    );

    await cubit.load();
    await cubit.loadMore();

    expect(page, 2);
    expect(cubit.state.events.length, ActivityCubit.pageSize * 2);
    expect(cubit.state.events.first.eventId, 'event-1-0');
    expect(cubit.state.events.last.eventId, 'event-2-19');
  });

  test('a failed second page keeps the rows already read', () async {
    var calls = 0;
    final cubit = _cubit(
      MockClient((_) async {
        calls++;
        if (calls > 1) return http.Response('nope', 500);
        return _json({
          'items': List.generate(
            ActivityCubit.pageSize,
            (index) => _event('event-$index', sequence: index + 1),
          ),
        });
      }),
    );

    await cubit.load();
    await cubit.loadMore();

    // Losing the trail because the next page failed would punish scrolling.
    expect(cubit.state.events.length, ActivityCubit.pageSize);
    expect(cubit.state.failed, isTrue);
  });

  test('an unreachable server is not reported as an empty life', () async {
    final cubit = _cubit(MockClient((_) async => http.Response('nope', 500)));

    await cubit.load();

    expect(cubit.state.failed, isTrue);
    expect(cubit.state.events, isEmpty);
  });

  test('a tampered entry is reported, not quietly passed', () async {
    final cubit = _cubit(
      MockClient((request) async {
        if (request.url.path.endsWith('/verify')) {
          return _json({
            'eventId': 'event-1',
            'contentHashValid': false,
            'signatureValid': true,
            'chainLinkValid': true,
            'verified': false,
          });
        }
        return _json({
          'items': [_event('event-1')],
        });
      }),
    );

    await cubit.load();
    await cubit.verify('event-1');

    final result = cubit.state.checked['event-1']!;
    expect(result.verified, isFalse);
    expect(result.contentHashValid, isFalse);
    expect(result.signatureValid, isTrue);
    expect(cubit.state.verifyingIds, isEmpty);
  });

  test('a check that could not run rethrows instead of passing', () async {
    final cubit = _cubit(
      MockClient((request) async {
        if (request.url.path.endsWith('/verify')) {
          return http.Response('nope', 500);
        }
        return _json({
          'items': [_event('event-1')],
        });
      }),
    );

    await cubit.load();

    await expectLater(cubit.verify('event-1'), throwsA(isA<Exception>()));
    expect(cubit.state.checked, isEmpty);
    expect(cubit.state.verifyingIds, isEmpty);
  });
}
