import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';

/// Captures the URL the data source asks for.
(RemoteDataSource, List<Uri>) _spy() {
  final calls = <Uri>[];
  final client = MockClient((request) async {
    calls.add(request.url);
    return http.Response(jsonEncode({'items': <Object?>[]}), 200);
  });
  return (
    RemoteDataSource(
      ApiClient(
        baseUrl: 'http://localhost:5050',
        tokenReader: () => null,
        client: client,
      ),
    ),
    calls,
  );
}

void main() {
  group('shops()', () {
    test('asks the server for just the nearby circle', () async {
      final (remote, calls) = _spy();

      await remote.shops(near: const GeoPoint(10.7721, 106.6980));

      final query = calls.single.queryParameters;
      expect(query['lat'], '10.7721');
      expect(query['lng'], '106.698');
      // The outer ring; the 5 km preference is applied on what comes back.
      expect(query['radiusKm'], '20.0');
    });

    test('sends no location parameters when there is no location', () async {
      final (remote, calls) = _spy();

      await remote.shops();

      final query = calls.single.queryParameters;
      // Sending one alone is a 400: the three go together or none do.
      expect(query.containsKey('lat'), isFalse);
      expect(query.containsKey('lng'), isFalse);
      expect(query.containsKey('radiusKm'), isFalse);
    });

    test('treats (0, 0) as no location rather than as a place', () async {
      final (remote, calls) = _spy();

      await remote.shops(near: const GeoPoint(0, 0));

      expect(calls.single.queryParameters.containsKey('lat'), isFalse);
    });
  });
}
