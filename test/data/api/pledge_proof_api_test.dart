import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/models.dart';

RemoteDataSource _source(
  Future<http.Response> Function(http.Request request) handler,
) {
  return RemoteDataSource(
    ApiClient(
      baseUrl: 'http://localhost:5000',
      tokenReader: () => 'token',
      client: MockClient(handler),
    ),
  );
}

http.Response _json(Object? body, {int status = 200}) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json'},
);

void main() {
  group('pledgeProof', () {
    test('requests the proof endpoint and parses the verdict', () async {
      late Uri seen;
      final source = _source((request) async {
        seen = request.url;
        return _json({
          'pledgeId': 'p1',
          'shopId': 's1',
          'committedAt': '2026-08-20T10:16:24.236Z',
          'proofStatus': 'verified',
          'recommendedActions': ['show_verified_badge'],
          'integrity': {'chainTxHash': '0xabc', 'onChainMatch': true},
        });
      });

      final proof = await source.pledgeProof('s1', 'p1');

      expect(seen.path, '/v1/shops/s1/pledges/p1/proof');
      expect(proof.status, ProofStatus.verified);
      expect(proof.integrity.chainTxHash, '0xabc');
    });

    test('degrades to an unknown proof when the request fails', () async {
      final source = _source(
        (request) async => _json({'error': 'boom'}, status: 500),
      );

      final proof = await source.pledgeProof('s1', 'p1');

      // Trust info must never take the screen down with it.
      expect(proof.status, ProofStatus.unknown);
      expect(proof.pledgeId, 'p1');
      expect(proof.shopId, 's1');
    });
  });

  group('latestProductProof', () {
    test('uses the newest pledge returned for the product', () async {
      final requested = <String>[];
      final source = _source((request) async {
        requested.add(request.url.path);
        if (request.url.path == '/v1/shops/s1/pledges') {
          expect(request.url.queryParameters['productId'], 'prod-1');
          // The server returns pledges newest-first.
          return _json({
            'items': [
              {'pledgeId': 'newest', 'committedAt': '2026-08-20T10:00:00Z'},
              {'pledgeId': 'older', 'committedAt': '2026-08-19T10:00:00Z'},
            ],
          });
        }
        return _json({
          'pledgeId': 'newest',
          'shopId': 's1',
          'committedAt': '2026-08-20T10:00:00Z',
          'proofStatus': 'verified',
        });
      });

      final proof = await source.latestProductProof('s1', 'prod-1');

      expect(proof, isNotNull);
      expect(proof!.pledgeId, 'newest');
      expect(requested, contains('/v1/shops/s1/pledges/newest/proof'));
    });

    test('returns null when the product has no pledge', () async {
      final source = _source((request) async => _json({'items': <Object?>[]}));

      expect(await source.latestProductProof('s1', 'prod-1'), isNull);
    });

    test('returns null when the pledge lookup fails', () async {
      final source = _source(
        (request) async => _json({'error': 'boom'}, status: 500),
      );

      expect(await source.latestProductProof('s1', 'prod-1'), isNull);
    });
  });
}
