import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/explore/controllers/explore_cubit.dart';

void main() {
  tearDown(MockDb.instance.resetForTesting);

  testWidgets('typing does not fire a request per keystroke', (tester) async {
    // "rau sạch" used to send eight requests, one per letter, over the weak
    // connection this app is used on - and whichever answer came back last
    // won, so the list could end up showing the results for a prefix.
    var requests = 0;
    final queries = <String>[];
    final cubit = ExploreCubit(
      repositories: AppRepositories.forTesting(
        MockDb.instance,
        RemoteDataSource(
          ApiClient(
            baseUrl: 'http://localhost:5050',
            tokenReader: () => 'token',
            client: MockClient((request) async {
              requests++;
              queries.add(request.url.queryParameters['q'] ?? '');
              return http.Response(jsonEncode({'items': <Object?>[]}), 200);
            }),
          ),
        ),
      ),
    );

    for (final query in ['r', 'ra', 'rau', 'rau ', 'rau s']) {
      cubit.setQuery(query);
      await tester.pump(const Duration(milliseconds: 80));
    }

    // Nothing has gone out yet: the reader is still typing.
    expect(requests, 0);

    await tester.pump(ExploreCubit.searchDebounce);
    await tester.pumpAndSettle();

    expect(requests, 1);
    expect(queries.single, 'rau s');

    await cubit.close();
  });

  testWidgets('the list still narrows on every letter', (tester) async {
    final cubit = ExploreCubit(
      repositories: AppRepositories.forTesting(MockDb.instance, null),
    );

    cubit.setQuery('rau');

    // Local filtering is immediate; only the server call waits.
    expect(cubit.state.query, 'rau');

    await tester.pump(ExploreCubit.searchDebounce);
    await cubit.close();
  });
}
