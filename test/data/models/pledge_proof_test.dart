import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';

/// Captured verbatim from the running server so the parser is tested against a
/// real payload, not an idealised one.
const _verifiedPayload = <String, Object?>{
  'pledgeId': 'a273aaf8-801c-4df1-a04a-b20f38936cb6',
  'shopId': 'f81e80d0-4c9a-47f5-8eee-9566c9db9bf6',
  'productId': 'cd02ad8c-a362-477c-adfc-12abfc334c8b',
  'bundleId': 'e2e-bundle-165921787220984',
  'score': 8.6,
  'category': 'fresh_produce',
  'confidence': 0.92,
  'committedAt': '2026-08-20T10:16:24.236Z',
  'imageHash': 'e2e-manual-image-hash',
  'proofStatus': 'verified',
  'proofHeadline': 'Cam ket da duoc xac thuc',
  'proofSummary': 'Hash da duoc neo va doi chieu khop tren blockchain.',
  'recommendedActions': <Object?>['show_verified_badge'],
  'integrity': <String, Object?>{
    'pledgeId': 'a273aaf8-801c-4df1-a04a-b20f38936cb6',
    'shopId': 'f81e80d0-4c9a-47f5-8eee-9566c9db9bf6',
    'dataHash':
        '2586dbf04c267a3d0b6fdb36c4813228bd5494d37585327bf088ff866a5b6df3',
    'chainTxHash':
        '0x485bca12c24aa4496f066e8d82678c6c330d92639bb50b91a038a5c92db0f285',
    'chainBlockNumber': 548,
    'chainAnchorStatus': 'anchored',
    'integrityStatus': 'anchored',
    'onChainMatch': true,
    'onChainPresent': true,
    'onChainVersion': 1,
    'onChainTimestamp': '2026-08-20T10:16:30.000Z',
    'canReanchor': false,
    'canRevoke': true,
  },
};

void main() {
  group('PledgeProof', () {
    test('parses a verified proof from the server', () {
      final proof = PledgeProof.fromJson(_verifiedPayload);

      expect(proof.status, ProofStatus.verified);
      expect(proof.pledgeId, 'a273aaf8-801c-4df1-a04a-b20f38936cb6');
      expect(proof.score, 8.6);
      expect(proof.hasAction(ProofActions.showVerifiedBadge), isTrue);
      expect(proof.showBadge, isTrue);
      expect(proof.canRetry, isFalse);

      expect(proof.integrity.onChainMatch, isTrue);
      expect(proof.integrity.chainBlockNumber, 548);
      expect(proof.integrity.hasChainRecord, isTrue);
      expect(proof.integrity.onChainTimestamp, isNotNull);
      expect(proof.committedAt.year, 2026);
    });

    test('parses a pending proof and asks the view to allow a retry', () {
      final proof = PledgeProof.fromJson(<String, Object?>{
        'pledgeId': 'p1',
        'shopId': 's1',
        'committedAt': '2026-08-20T10:16:24.236Z',
        'proofStatus': 'pending',
        'proofHeadline': 'Dang cho neo len blockchain',
        'recommendedActions': <Object?>['show_pending_badge', 'retry_later'],
        'integrity': <String, Object?>{
          'chainAnchorStatus': 'pending_anchor',
          'integrityStatus': 'pending_anchor',
          'onChainMatch': false,
          'onChainPresent': false,
          'mismatchReason': 'missing_on_chain_record',
        },
      });

      expect(proof.status, ProofStatus.pending);
      expect(proof.canRetry, isTrue);
      expect(proof.showBadge, isTrue);
      expect(proof.integrity.hasChainRecord, isFalse);
      expect(proof.integrity.chainAnchorTime, isNull);
      expect(proof.integrity.mismatchReason, 'missing_on_chain_record');
    });

    test('hides the badge when the server revokes a pledge', () {
      final proof = PledgeProof.fromJson(<String, Object?>{
        'pledgeId': 'p1',
        'shopId': 's1',
        'committedAt': '2026-08-20T10:16:24.236Z',
        'proofStatus': 'revoked',
        'recommendedActions': <Object?>[
          'hide_trust_badge',
          'show_revoked_state',
        ],
      });

      expect(proof.status, ProofStatus.revoked);
      expect(proof.showBadge, isFalse);
    });

    test('falls back to unknown for a status it does not recognise', () {
      final proof = PledgeProof.fromJson(<String, Object?>{
        'pledgeId': 'p1',
        'shopId': 's1',
        'committedAt': '2026-08-20T10:16:24.236Z',
        'proofStatus': 'something_new_from_a_newer_server',
      });

      expect(proof.status, ProofStatus.unknown);
    });

    test('survives a payload with no integrity block', () {
      final proof = PledgeProof.fromJson(<String, Object?>{
        'pledgeId': 'p1',
        'shopId': 's1',
        'committedAt': '2026-08-20T10:16:24.236Z',
        'proofStatus': 'verified',
      });

      expect(proof.integrity.chainTxHash, isEmpty);
      expect(proof.integrity.hasChainRecord, isFalse);
    });

    test('unknown() yields a neutral proof for failed lookups', () {
      final proof = PledgeProof.unknown(pledgeId: 'p1', shopId: 's1');

      expect(proof.status, ProofStatus.unknown);
      expect(proof.showBadge, isTrue);
      expect(proof.hasAction(ProofActions.showNeutralState), isTrue);
    });

    test('round-trips through toJson', () {
      final proof = PledgeProof.fromJson(_verifiedPayload);
      final again = PledgeProof.fromJson(proof.toJson());

      expect(again.status, proof.status);
      expect(again.integrity.chainTxHash, proof.integrity.chainTxHash);
      expect(again.integrity.chainBlockNumber, proof.integrity.chainBlockNumber);
      expect(again.recommendedActions, proof.recommendedActions);
    });
  });
}
