class PledgeHistoryItem {
  final String time;
  final String title;
  final String description;
  final bool isVerified;
  final bool hasProof;
  final String proofId;

  const PledgeHistoryItem({
    required this.time,
    required this.title,
    required this.description,
    required this.isVerified,
    this.hasProof = false,
    this.proofId = '',
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
      title: json['title']?.toString() ?? 'Ghi nhận độ tươi',
      description:
          json['description']?.toString() ??
          (score == null
              ? ''
              : 'Điểm ${score.toStringAsFixed(1)}/10 · ${category ?? ''}'),
      isVerified: json['isVerified'] as bool? ?? isAnchoredStatus(integrity),
      hasProof: json['hasProof'] as bool? ?? pledgeId != null,
      proofId: json['proofId']?.toString() ?? pledgeId ?? '',
    );
  }

  Map<String, Object?> toJson() => {
    'time': time,
    'title': title,
    'description': description,
    'isVerified': isVerified,
    'hasProof': hasProof,
    'proofId': proofId,
  };
}
