import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';

Map<String, Object?> _shopJson(String id) => {
  'shopId': id,
  'name': 'Shop $id',
  'address': 'addr',
  'description': '',
  'latitude': 10.7721,
  'longitude': 106.6980,
};

AppRepositories _repositories(http.Client client) => AppRepositories.forTesting(
  MockDb.instance,
  RemoteDataSource(
    ApiClient(
      baseUrl: 'http://localhost:5050',
      tokenReader: () => null,
      client: client,
    ),
  ),
);

/// Serves shops only when the request carries no radius, the way the server
/// behaves for a reader standing outside every shop's circle.
(AppRepositories, List<Uri>) _backend({required bool emptyWhenNarrowed}) {
  final calls = <Uri>[];
  final client = MockClient((request) async {
    calls.add(request.url);
    final narrowed = request.url.queryParameters.containsKey('radiusKm');
    final items = narrowed && emptyWhenNarrowed
        ? <Object?>[]
        : [_shopJson('s1'), _shopJson('s2')];
    return http.Response(jsonEncode({'items': items}), 200);
  });

  return (_repositories(client), calls);
}

void main() {
  setUp(() => MockDb.instance.shops.clear());
  tearDown(MockDb.instance.resetForTesting);

  const somewhereElse = GeoPoint(37.4220, -122.0840);

  test('an empty radius result falls back to the whole catalogue', () async {
    // Otherwise a reader outside every shop's 20 km circle is handed nothing,
    // and the app has nothing left to show as "the closest anyway".
    final (repositories, calls) = _backend(emptyWhenNarrowed: true);

    final shops = await repositories.shops.refresh(near: somewhereElse);

    expect(shops, hasLength(2));
    expect(calls, hasLength(2));
    expect(calls.first.queryParameters.containsKey('radiusKm'), isTrue);
    expect(calls.last.queryParameters.containsKey('radiusKm'), isFalse);
  });

  test('a radius that finds shops does not fetch again', () async {
    final (repositories, calls) = _backend(emptyWhenNarrowed: false);

    final shops = await repositories.shops.refresh(near: somewhereElse);

    expect(shops, hasLength(2));
    expect(calls, hasLength(1));
  });

  test('with no location there is no narrowed request to retry', () async {
    final (repositories, calls) = _backend(emptyWhenNarrowed: true);

    await repositories.shops.refresh();

    expect(calls, hasLength(1));
  });

  test('a genuinely empty catalogue is not retried forever', () async {
    final calls = <Uri>[];
    final repositories = _repositories(
      MockClient((request) async {
        calls.add(request.url);
        return http.Response(jsonEncode({'items': <Object?>[]}), 200);
      }),
    );

    final shops = await repositories.shops.refresh(near: somewhereElse);

    expect(shops, isEmpty);
    // One narrowed attempt, one unfiltered attempt, and then it stops.
    expect(calls, hasLength(2));
  });
}
