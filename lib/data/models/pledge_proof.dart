import 'json_helpers.dart';

/// Verdicts the server can return in `proofStatus`.
enum ProofStatus {
  verified,
  pending,
  warning,
  revoked,
  unknown;

  static ProofStatus parse(Object? value) {
    switch (value?.toString()) {
      case 'verified':
        return ProofStatus.verified;
      case 'pending':
        return ProofStatus.pending;
      case 'warning':
        return ProofStatus.warning;
      case 'revoked':
        return ProofStatus.revoked;
      default:
        // An unrecognised status is treated as "cannot verify" rather than as a
        // failure, so a newer server never makes the app claim something false.
        return ProofStatus.unknown;
    }
  }
}

/// UI directives the server sends alongside the verdict. The app follows these
/// instead of deriving its own presentation rules from [ProofStatus], so the
/// two sides cannot drift apart.
class ProofActions {
  static const showVerifiedBadge = 'show_verified_badge';
  static const showPendingBadge = 'show_pending_badge';
  static const showWarning = 'show_warning';
  static const showRevokedState = 'show_revoked_state';
  static const showNeutralState = 'show_neutral_state';
  static const hideTrustBadge = 'hide_trust_badge';
  static const retryLater = 'retry_later';
  static const contactAdmin = 'contact_admin';
  static const considerReanchor = 'consider_reanchor';
  static const refreshRecord = 'refresh_record';
}

/// On-chain anchoring details for a pledge.
class PledgeIntegrity {
  final String dataHash;
  final String chainTxHash;
  final int chainBlockNumber;
  final String chainAnchorStatus;
  final String integrityStatus;
  final bool onChainMatch;
  final bool onChainPresent;
  final String onChainDataHash;
  final DateTime? onChainTimestamp;
  final DateTime? chainAnchorTime;
  final String mismatchReason;

  const PledgeIntegrity({
    this.dataHash = '',
    this.chainTxHash = '',
    this.chainBlockNumber = 0,
    this.chainAnchorStatus = '',
    this.integrityStatus = '',
    this.onChainMatch = false,
    this.onChainPresent = false,
    this.onChainDataHash = '',
    this.onChainTimestamp,
    this.chainAnchorTime,
    this.mismatchReason = '',
  });

  /// True once the pledge has a transaction on chain to point at.
  bool get hasChainRecord => chainTxHash.isNotEmpty;

  factory PledgeIntegrity.fromJson(Map<String, Object?> json) {
    return PledgeIntegrity(
      dataHash: json['dataHash']?.toString() ?? '',
      chainTxHash: json['chainTxHash']?.toString() ?? '',
      chainBlockNumber: (json['chainBlockNumber'] as num?)?.toInt() ?? 0,
      chainAnchorStatus: json['chainAnchorStatus']?.toString() ?? '',
      integrityStatus: json['integrityStatus']?.toString() ?? '',
      onChainMatch: json['onChainMatch'] == true,
      onChainPresent: json['onChainPresent'] == true,
      onChainDataHash: json['onChainDataHash']?.toString() ?? '',
      onChainTimestamp: optionalDateTime(json['onChainTimestamp']),
      chainAnchorTime: optionalDateTime(json['chainAnchorTime']),
      mismatchReason: json['mismatchReason']?.toString() ?? '',
    );
  }

  Map<String, Object?> toJson() => {
    'dataHash': dataHash,
    'chainTxHash': chainTxHash,
    'chainBlockNumber': chainBlockNumber,
    'chainAnchorStatus': chainAnchorStatus,
    'integrityStatus': integrityStatus,
    'onChainMatch': onChainMatch,
    'onChainPresent': onChainPresent,
    'onChainDataHash': onChainDataHash,
    'onChainTimestamp': onChainTimestamp?.toIso8601String(),
    'chainAnchorTime': chainAnchorTime?.toIso8601String(),
    'mismatchReason': mismatchReason,
  };
}

/// The server's blockchain verdict for one pledge, as returned by
/// `GET /v1/shops/{shopId}/pledges/{pledgeId}/proof`.
class PledgeProof {
  final String pledgeId;
  final String shopId;
  final String productId;
  final String bundleId;
  final double score;
  final String category;
  final double confidence;
  final DateTime committedAt;
  final String imageHash;
  final ProofStatus status;

  /// Server-authored copy. Kept as a fallback for when the app has no
  /// translation for a status it does not know about.
  final String headline;
  final String summary;

  final List<String> recommendedActions;
  final PledgeIntegrity integrity;

  const PledgeProof({
    required this.pledgeId,
    required this.shopId,
    required this.committedAt,
    required this.status,
    this.productId = '',
    this.bundleId = '',
    this.score = 0,
    this.category = '',
    this.confidence = 0,
    this.imageHash = '',
    this.headline = '',
    this.summary = '',
    this.recommendedActions = const [],
    this.integrity = const PledgeIntegrity(),
  });

  /// A proof with nothing known about it, used when the lookup fails so callers
  /// can render a neutral badge instead of an error.
  factory PledgeProof.unknown({String pledgeId = '', String shopId = ''}) {
    return PledgeProof(
      pledgeId: pledgeId,
      shopId: shopId,
      committedAt: DateTime.fromMillisecondsSinceEpoch(0),
      status: ProofStatus.unknown,
      recommendedActions: const [ProofActions.showNeutralState],
    );
  }

  bool hasAction(String action) => recommendedActions.contains(action);

  /// The server asks for the badge to be hidden when a pledge is revoked.
  bool get showBadge => !hasAction(ProofActions.hideTrustBadge);

  /// Anchoring is still in flight, so the view should offer a refresh.
  bool get canRetry => hasAction(ProofActions.retryLater);

  factory PledgeProof.fromJson(Map<String, Object?> json) {
    final integrity = json['integrity'];
    return PledgeProof(
      pledgeId: json['pledgeId']?.toString() ?? '',
      shopId: json['shopId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      bundleId: json['bundleId']?.toString() ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
      category: json['category']?.toString() ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      committedAt: dateTime(json['committedAt']),
      imageHash: json['imageHash']?.toString() ?? '',
      status: ProofStatus.parse(json['proofStatus']),
      headline: json['proofHeadline']?.toString() ?? '',
      summary: json['proofSummary']?.toString() ?? '',
      recommendedActions: stringList(json['recommendedActions']),
      integrity: integrity is Map
          ? PledgeIntegrity.fromJson(Map<String, Object?>.from(integrity))
          : const PledgeIntegrity(),
    );
  }

  Map<String, Object?> toJson() => {
    'pledgeId': pledgeId,
    'shopId': shopId,
    'productId': productId,
    'bundleId': bundleId,
    'score': score,
    'category': category,
    'confidence': confidence,
    'committedAt': committedAt.toIso8601String(),
    'imageHash': imageHash,
    'proofStatus': status.name,
    'proofHeadline': headline,
    'proofSummary': summary,
    'recommendedActions': recommendedActions,
    'integrity': integrity.toJson(),
  };
}
