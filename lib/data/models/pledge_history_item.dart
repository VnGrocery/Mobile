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

  factory PledgeHistoryItem.fromJson(Map<String, Object?> json) {
    return PledgeHistoryItem(
      time: json['time'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isVerified: json['isVerified'] as bool,
      hasProof: json['hasProof'] as bool? ?? false,
      proofId: json['proofId'] as String? ?? '',
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
