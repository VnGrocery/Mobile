import 'json_helpers.dart';

/// What a shop or product has collected, and what this reader put there.
///
/// The counts come with the anchor beside them on purpose: a follower figure
/// with nothing behind it is only the server's word for it. [anchored] is what
/// the badge reads, and it is false while a fresh tap waits for its block.
class Engagement {
  final String targetType;
  final String targetId;

  final int follows;
  final int likes;
  final int loves;

  /// Kinds this reader has marked: follow, like, love.
  final Set<String> mine;

  final String chainTxHash;
  final DateTime? anchoredAt;
  final String anchorStatus;

  const Engagement({
    required this.targetType,
    required this.targetId,
    this.follows = 0,
    this.likes = 0,
    this.loves = 0,
    this.mine = const {},
    this.chainTxHash = '',
    this.anchoredAt,
    this.anchorStatus = '',
  });

  bool get following => mine.contains('follow');
  bool get liked => mine.contains('like');
  bool get loved => mine.contains('love');

  /// Whether the figures shown are the ones written to a block. A tap that has
  /// not been mined yet is honest about waiting rather than claiming a proof
  /// it does not have.
  bool get anchored => anchorStatus == 'anchored' && chainTxHash.isNotEmpty;

  factory Engagement.fromJson(Map<String, Object?> json) {
    return Engagement(
      targetType: json['targetType'] as String? ?? '',
      targetId: json['targetId'] as String? ?? '',
      follows: (json['follows'] as num?)?.toInt() ?? 0,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      loves: (json['loves'] as num?)?.toInt() ?? 0,
      mine: ((json['mine'] as List?) ?? const [])
          .map((kind) => kind.toString())
          .toSet(),
      chainTxHash: json['chainTxHash'] as String? ?? '',
      anchoredAt: json['chainAnchorTime'] == null
          ? null
          : dateTime(json['chainAnchorTime']),
      anchorStatus: json['anchorStatus'] as String? ?? '',
    );
  }
}
