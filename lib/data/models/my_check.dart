import 'json_helpers.dart';

/// One check the reader made at a stall, as it reads back later.
///
/// The list this belongs to can only be filled by standing in front of goods
/// and photographing them, so an empty one means exactly that and never a
/// loading state or a missing feature.
class MyCheck {
  final String id;
  final String shopId;
  final String productId;
  final String productName;
  final String shopName;

  /// `trusted`, `warning`, `mismatch`, `no_pledge` - the server's verdict.
  final String verdict;
  final double pledgedScore;
  final double actualScore;
  final bool hasPledge;
  final DateTime createdAt;

  /// `completed`, `flagged`, `rejected`, `pending_review`.
  ///
  /// Only `pending_review` is new to the reader: the photo was taken and
  /// stored, but the server's AI never got to look at it, so there is no
  /// verdict yet and the check counts for nothing.
  final String status;

  /// The photo the reader took, as a gateway URL. Empty when the upload failed
  /// or the record predates the field.
  final String imageUrl;

  const MyCheck({
    required this.id,
    required this.shopId,
    required this.productId,
    required this.productName,
    required this.shopName,
    required this.verdict,
    required this.pledgedScore,
    required this.actualScore,
    required this.hasPledge,
    required this.createdAt,
    this.status = '',
    this.imageUrl = '',
  });

  /// No AI has scored this yet, so nothing on it is a judgement of the shop.
  bool get isPendingReview => status == 'pending_review';

  factory MyCheck.fromJson(Map<String, Object?> json) => MyCheck(
    id: json['checkId']?.toString() ?? '',
    shopId: json['shopId']?.toString() ?? '',
    productId: json['productId']?.toString() ?? '',
    productName: json['productName']?.toString() ?? '',
    shopName: json['shopName']?.toString() ?? '',
    verdict: json['verdict']?.toString() ?? '',
    pledgedScore: (json['pledgedScore'] as num?)?.toDouble() ?? 0,
    actualScore: (json['actualScore'] as num?)?.toDouble() ?? 0,
    hasPledge: json['hasPledge'] == true,
    createdAt: dateTime(json['createdAt']),
    status: json['status']?.toString() ?? '',
    imageUrl: json['imageUrl']?.toString() ?? '',
  );
}
