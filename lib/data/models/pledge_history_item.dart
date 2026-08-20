class PledgeHistoryItem {
  final String time;
  final String title;
  final String description;
  final bool isVerified;
  final bool hasProof;
  final String proofId;

  /// Raw server status: pending_anchor, anchored, mismatch_detected, revoked or
  /// reanchored. Kept alongside [isVerified] so the timeline can say which of
  /// the "not verified" states a pledge is actually in.
  final String integrityStatus;

  /// Freshness score the seller pledged, when the server sent one. Kept raw so
  /// the UI can word it in the reader's language.
  final double? score;

  /// Raw category key, e.g. `fresh_produce`. Also kept raw: the old code baked
  /// it straight into a Vietnamese sentence, so English readers saw a
  /// Vietnamese line and everyone saw the snake_case key.
  final String? category;

  const PledgeHistoryItem({
    required this.time,
    required this.title,
    required this.description,
    required this.isVerified,
    this.hasProof = false,
    this.proofId = '',
    this.integrityStatus = '',
    this.score,
    this.category,
  });

  /// Values the server can put in `integrityStatus`. `verified` is not one of
  /// them, which is why the tick never used to appear.
  static const _anchoredStatuses = {'anchored', 'reanchored'};

  static bool isAnchoredStatus(String? integrityStatus) =>
      _anchoredStatuses.contains(integrityStatus);

  factory PledgeHistoryItem.fromJson(Map<String, Object?> json) {
    final score = (json['score'] as num?)?.toDouble();
    final category = json['category']?.toString();
    final integrity = json['integrityStatus']?.toString();
    final pledgeId = json['pledgeId']?.toString();
    return PledgeHistoryItem(
      time: (json['time'] ?? json['committedAt'] ?? '').toString(),
      // Left empty when the server says nothing; the UI supplies the wording.
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isVerified: json['isVerified'] as bool? ?? isAnchoredStatus(integrity),
      hasProof: json['hasProof'] as bool? ?? pledgeId != null,
      proofId: json['proofId']?.toString() ?? pledgeId ?? '',
      integrityStatus: integrity ?? '',
      score: score,
      category: category,
    );
  }

  Map<String, Object?> toJson() => {
    'time': time,
    'title': title,
    'description': description,
    'isVerified': isVerified,
    'hasProof': hasProof,
    'proofId': proofId,
    'integrityStatus': integrityStatus,
    'score': score,
    'category': category,
  };
}
