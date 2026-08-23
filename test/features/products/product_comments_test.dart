import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/products/controllers/product_comments_cubit.dart';

http.Response _json(Object body) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  200,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

ProductCommentsCubit _cubit(MockClient client) => ProductCommentsCubit(
  shopId: 'shop-1',
  productId: 'p-1',
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

  test('a moderated shop still has to report what it is holding back', () async {
    // The whole point of the switch: a filtered stall must not be able to look
    // like a quiet one, so the counts arrive even though the text does not.
    final cubit = _cubit(
      MockClient(
        (request) async => _json({
          'items': <Object>[],
          'moderation': true,
          'approvedCount': 0,
          'pendingCount': 2,
          'rejectedCount': 1,
          'canComment': false,
        }),
      ),
    );
    await cubit.load();

    expect(cubit.state.thread.moderation, isTrue);
    expect(cubit.state.thread.withheldCount, 3);
    expect(cubit.state.thread.isEmpty, isTrue);
    expect(cubit.state.failed, isFalse);
  });

  test(
    'an unreachable comment section is not reported as an empty one',
    () async {
      final cubit = _cubit(
        MockClient((request) async => http.Response('nope', 500)),
      );
      await cubit.load();

      // Both leave the list empty, so the flag is the only thing that keeps
      // "could not read" from being shown as "nobody said anything".
      expect(cubit.state.failed, isTrue);
      expect(cubit.state.thread.isEmpty, isTrue);
    },
  );

  test('a comment carries the check that backs it', () async {
    final cubit = _cubit(
      MockClient(
        (request) async => _json({
          'items': [
            {
              'commentId': 'c-1',
              'shopId': 'shop-1',
              'productId': 'p-1',
              'authorUserId': 'u-1',
              'authorName': 'Khách hàng 2',
              'body': 'Rau còn tươi đúng như ghi nhận',
              'status': 'approved',
              'checkId': 'chk-1',
              'verdict': 'trusted',
              'version': 1,
              'createdAt': '2026-08-24T03:15:00Z',
              'updatedAt': '2026-08-24T03:15:00Z',
            },
          ],
          'moderation': false,
          'approvedCount': 1,
          'pendingCount': 0,
          'rejectedCount': 0,
          'canComment': true,
        }),
      ),
    );
    await cubit.load();

    final comment = cubit.state.thread.items.single;
    expect(comment.isVerified, isTrue);
    expect(comment.isApproved, isTrue);
    expect(cubit.state.thread.canComment, isTrue);
  });

  test('writing sends the body and re-reads the server verdict', () async {
    Map<String, Object?>? sent;
    var listed = 0;
    final cubit = _cubit(
      MockClient((request) async {
        if (request.method == 'POST') {
          sent = jsonDecode(request.body) as Map<String, Object?>;
          return http.Response.bytes(
            utf8.encode(jsonEncode({'commentId': 'c-1', 'status': 'pending'})),
            201,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        listed++;
        return _json({
          'items': <Object>[],
          'moderation': true,
          'approvedCount': 0,
          'pendingCount': 1,
          'rejectedCount': 0,
          'canComment': true,
        });
      }),
    );
    await cubit.submit('Rau còn tươi đúng như ghi nhận');

    expect(sent?['body'], 'Rau còn tươi đúng như ghi nhận');
    // Reloaded rather than assumed: whether the comment is published or held
    // is the server's call, not this app's.
    expect(listed, 1);
    expect(cubit.state.thread.pendingCount, 1);
  });
}
