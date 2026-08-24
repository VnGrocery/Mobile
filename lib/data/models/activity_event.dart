import 'json_helpers.dart';

/// One signed entry from the reader's own trail.
///
/// Every like, follow, comment and check writes one of these, hash-chained to
/// the one before it through [previousEventId]. The chain is what makes a
/// history worth reading: a row that could be edited afterwards would only be
/// a list of claims.
class ActivityEvent {
  final String eventId;
  final String action;

  /// The action's qualifier. For a follow or a heart this is the kind that was
  /// marked, which is the only place the difference between a like and a love
  /// survives into the log.
  final String status;

  final String resourceType;
  final String resourceId;
  final int sequence;
  final String previousEventId;
  final String contentSha256;
  final String signature;
  final DateTime createdAt;

  const ActivityEvent({
    required this.eventId,
    required this.action,
    this.status = '',
    this.resourceType = '',
    this.resourceId = '',
    this.sequence = 0,
    this.previousEventId = '',
    this.contentSha256 = '',
    this.signature = '',
    required this.createdAt,
  });

  /// Whether this entry carries the proof needed to check it later. An entry
  /// without a signature can be shown, but it must not be offered as evidence.
  bool get signed => signature.isNotEmpty && contentSha256.isNotEmpty;

  factory ActivityEvent.fromJson(Map<String, Object?> json) {
    return ActivityEvent(
      eventId: json['eventId'] as String? ?? '',
      action: json['action'] as String? ?? '',
      status: json['status'] as String? ?? '',
      resourceType: json['resourceType'] as String? ?? '',
      resourceId: json['resourceId'] as String? ?? '',
      sequence: (json['sequence'] as num?)?.toInt() ?? 0,
      previousEventId: json['previousEventId'] as String? ?? '',
      contentSha256: json['contentSha256'] as String? ?? '',
      signature: json['signature'] as String? ?? '',
      createdAt: dateTime(json['createdAt'] ?? json['occurredAt']),
    );
  }
}

/// The answer to "is this entry still what it says it is".
///
/// Every flag is reported separately because they fail for different reasons:
/// a broken [chainLinkValid] with a good [signatureValid] means an entry was
/// removed from the middle, not that this one was tampered with.
class ActivityVerification {
  final String eventId;
  final bool contentHashValid;
  final bool signatureValid;
  final bool chainLinkValid;
  final bool verified;

  const ActivityVerification({
    required this.eventId,
    this.contentHashValid = false,
    this.signatureValid = false,
    this.chainLinkValid = false,
    this.verified = false,
  });

  factory ActivityVerification.fromJson(Map<String, Object?> json) {
    return ActivityVerification(
      eventId: json['eventId'] as String? ?? '',
      contentHashValid: json['contentHashValid'] as bool? ?? false,
      signatureValid: json['signatureValid'] as bool? ?? false,
      chainLinkValid: json['chainLinkValid'] as bool? ?? false,
      verified: json['verified'] as bool? ?? false,
    );
  }
}
