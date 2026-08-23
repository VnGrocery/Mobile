import 'json_helpers.dart';

/// What a buyer wrote about a product after checking it at the stall.
class ProductComment {
  final String id;
  final String shopId;
  final String productId;
  final String authorUserId;

  /// Empty when the account has no display name; the view shows a generic
  /// label rather than the raw user id.
  final String authorName;
  final String body;

  /// `approved`, `pending`, `rejected` or `deleted`.
  final String status;

  /// The buyer check this comment rests on. Non-empty means the writer stood
  /// in front of the goods, which is what the badge says.
  final String checkId;
  final String verdict;

  /// Why the shop published or hid it, in the shop's own words. Signed with
  /// the decision, so it cannot be rewritten later.
  final String moderationReason;
  final DateTime? moderatedAt;

  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductComment({
    required this.id,
    required this.shopId,
    required this.productId,
    required this.authorUserId,
    required this.authorName,
    required this.body,
    required this.status,
    required this.checkId,
    required this.verdict,
    required this.moderationReason,
    required this.moderatedAt,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';

  /// True when a buyer check backs the words.
  bool get isVerified => checkId.isNotEmpty;

  factory ProductComment.fromJson(Map<String, Object?> json) => ProductComment(
    id: json['commentId']?.toString() ?? '',
    shopId: json['shopId']?.toString() ?? '',
    productId: json['productId']?.toString() ?? '',
    authorUserId: json['authorUserId']?.toString() ?? '',
    authorName: json['authorName']?.toString() ?? '',
    body: json['body']?.toString() ?? '',
    status: json['status']?.toString() ?? '',
    checkId: json['checkId']?.toString() ?? '',
    verdict: json['verdict']?.toString() ?? '',
    moderationReason: json['moderationReason']?.toString() ?? '',
    moderatedAt: optionalDateTime(json['moderatedAt']),
    version: (json['version'] as num?)?.toInt() ?? 0,
    createdAt: dateTime(json['createdAt']),
    updatedAt: dateTime(json['updatedAt']),
  );
}

/// The comment section of one product, counts included.
///
/// The counts are the point of the whole feature: a shop that screens comments
/// still has to show how many it is holding back, so a reader can tell a quiet
/// stall from a filtered one.
class ProductCommentThread {
  final List<ProductComment> items;

  /// The shop screens comments before anyone reads them.
  final bool moderation;

  final int approvedCount;
  final int pendingCount;
  final int rejectedCount;

  /// The reader has checked this product and may write. False means the write
  /// box is replaced by the line explaining what to do first.
  final bool canComment;

  const ProductCommentThread({
    this.items = const [],
    this.moderation = false,
    this.approvedCount = 0,
    this.pendingCount = 0,
    this.rejectedCount = 0,
    this.canComment = false,
  });

  /// How many comments exist that the reader is not being shown.
  int get withheldCount => pendingCount + rejectedCount;

  bool get isEmpty => items.isEmpty;

  factory ProductCommentThread.fromJson(Map<String, Object?> json) {
    final rawItems = json['items'];
    return ProductCommentThread(
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map((item) => ProductComment.fromJson(item.cast()))
                .toList()
          : const [],
      moderation: json['moderation'] == true,
      approvedCount: (json['approvedCount'] as num?)?.toInt() ?? 0,
      pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
      rejectedCount: (json['rejectedCount'] as num?)?.toInt() ?? 0,
      canComment: json['canComment'] == true,
    );
  }
}
