import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/reviews/controllers/review_cubit.dart';

const _me = '5f049d73-3ad3-4618-84ee-06aa2e7fda8c';

/// One row of `GET /v1/shops/{id}/reviews`, in the shape the Go DTO writes it.
Map<String, Object?> _review({
  required String reviewerUserId,
  int version = 3,
}) => {
  'reviewId': '7c0d2b11-0000-4000-8000-000000000001',
  'shopId': 's1',
  'reviewerUserId': reviewerUserId,
  'reviewerName': 'Người mua',
  'rating': 4,
  'comment': 'Rau tươi, giao nhanh.',
  'imageUrls': <String>[],
  'status': 'active',
  'version': version,
  'createdAt': '2026-09-19T11:21:00Z',
  'updatedAt': '2026-09-19T11:21:00Z',
};

void main() {
  test('a second review of the same shop replaces the first', () async {
    Map<String, Object?>? sent;
    final repositories = AppRepositories.forTesting(
      MockDb.instance,
      RemoteDataSource(
        ApiClient(
          baseUrl: 'http://localhost',
          tokenReader: () => 'token',
          client: MockClient((request) async {
            if (request.method == 'GET') {
              return http.Response.bytes(
                utf8.encode(jsonEncode([_review(reviewerUserId: _me)])),
                200,
                headers: {'content-type': 'application/json; charset=utf-8'},
              );
            }
            sent = jsonDecode(request.body) as Map<String, Object?>;
            return http.Response.bytes(
              utf8.encode(jsonEncode(_review(reviewerUserId: _me, version: 4))),
              201,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          }),
        ),
      ),
    );

    final cubit = ReviewCubit(
      shopId: 's1',
      repositories: repositories,
      reviewerUserId: _me,
    );

    // The form opens on what was written before, not on a blank field.
    expect(await cubit.loadExisting(), 'Rau tươi, giao nhanh.');
    expect(cubit.state.rating, 4);
    expect(cubit.state.editing, isTrue);

    cubit.setRating(5);
    await cubit.submit('Lần này còn tươi hơn');

    // 3, not 0. The hardcoded 0 was refused with a 409, so nobody could ever
    // review the same shop a second time.
    expect(sent?['expectedVersion'], 3);
    expect(cubit.state.submitted, isTrue);
    expect(cubit.state.failed, isFalse);

    await cubit.close();
  });

  test("someone else's review is not treated as mine", () async {
    final repositories = AppRepositories.forTesting(
      MockDb.instance,
      RemoteDataSource(
        ApiClient(
          baseUrl: 'http://localhost',
          tokenReader: () => 'token',
          client: MockClient(
            (_) async => http.Response.bytes(
              utf8.encode(
                jsonEncode([_review(reviewerUserId: 'another-account')]),
              ),
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            ),
          ),
        ),
      ),
    );

    final cubit = ReviewCubit(
      shopId: 's1',
      repositories: repositories,
      reviewerUserId: _me,
    );

    // Prefilling from a stranger's review would put their words in this
    // reader's mouth and send their version as the one being replaced.
    expect(await cubit.loadExisting(), isNull);
    expect(cubit.state.editing, isFalse);

    await cubit.close();
  });
}
