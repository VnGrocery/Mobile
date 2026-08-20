/// Smoke test that runs the app's own data layer against a running server.
///
/// Skipped during a normal `flutter test`. To run it, start the backend
/// (`cd server && ./scripts/vng up`), seed it (`./scripts/vng e2e`) and pass the
/// ids that command prints:
///
/// ```
/// flutter test test/live \
///   --dart-define=LIVE=true \
///   --dart-define=LIVE_BASE_URL=http://localhost:5000 \
///   --dart-define=LIVE_SHOP_ID=... \
///   --dart-define=LIVE_PRODUCT_ID=...
/// ```
// The whole point of this test is to print what the real server returned.
// ignore_for_file: avoid_print
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/models.dart';

const _enabled = bool.fromEnvironment('LIVE');
const _baseUrl = String.fromEnvironment(
  'LIVE_BASE_URL',
  defaultValue: 'http://localhost:5000',
);
const _shopId = String.fromEnvironment('LIVE_SHOP_ID');
const _productId = String.fromEnvironment('LIVE_PRODUCT_ID');

const _skipReason =
    'live server test: pass --dart-define=LIVE=true plus LIVE_SHOP_ID and '
    'LIVE_PRODUCT_ID from `./scripts/vng e2e`';

void main() {
  final source = RemoteDataSource(
    ApiClient(baseUrl: _baseUrl, tokenReader: () => null),
  );

  final skip = _enabled ? null : _skipReason;

  test('parses a real shop together with its trust summary', () async {
    final shops = await source.shops();
    expect(shops, isNotEmpty);

    final shop = shops.firstWhere(
      (s) => s.id == _shopId,
      orElse: () => throw StateError('shop $_shopId not found on $_baseUrl'),
    );
    final trust = shop.trustSummary;
    expect(trust, isNotNull, reason: 'server returned no trustSummary');

    print('shop            : ${shop.name}');
    print('trust score     : ${trust!.score} (${trust.grade.name})');
    print(
      'components      : '
      '${trust.components.map((c) => "${c.key}=${c.score}").join(", ")}',
    );
    print('reasons         : ${trust.reasons.join(", ")}');

    expect(trust.hasData, isTrue);
    expect(trust.components, hasLength(6));
  }, skip: skip);

  test('parses the real blockchain proof for a product', () async {
    final proof = await source.latestProductProof(_shopId, _productId);
    expect(proof, isNotNull, reason: 'no pledge found for $_productId');

    print('proofStatus     : ${proof!.status.name}');
    print('actions         : ${proof.recommendedActions.join(", ")}');
    print('chainTxHash     : ${proof.integrity.chainTxHash}');
    print('chainBlockNumber: ${proof.integrity.chainBlockNumber}');
    print('onChainMatch    : ${proof.integrity.onChainMatch}');
    print('dataHash        : ${proof.integrity.dataHash}');

    // Anchoring takes a few seconds; if this fails with pending, wait and rerun.
    expect(proof.status, ProofStatus.verified);
    expect(proof.integrity.onChainMatch, isTrue);
    expect(proof.integrity.hasChainRecord, isTrue);
    expect(proof.showBadge, isTrue);
  }, skip: skip);
}
