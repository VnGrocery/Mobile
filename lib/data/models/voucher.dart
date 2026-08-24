import 'json_helpers.dart';

class Voucher {
  final String id;
  final String code;
  final String title;
  final String shopId;
  final int discountValue;
  final bool isPercent;
  final int minSpend;
  final DateTime expiresAt;
  final bool? active;
  final bool? manual;
  final String note;
  final String codeFormat;

  /// How many claims the shop offered, and how many are gone. [limited] is
  /// false for an offer with no cap, and then [remaining] means nothing - the
  /// UI must not print a zero that reads as sold out.
  final int totalQuantity;
  final int claimedCount;
  final int remaining;
  final bool limited;
  final bool soldOut;

  const Voucher({
    required this.id,
    required this.code,
    required this.title,
    required this.shopId,
    required this.discountValue,
    required this.isPercent,
    required this.minSpend,
    required this.expiresAt,
    this.active = true,
    this.manual = false,
    this.note = '',
    this.codeFormat = 'QR',
    this.totalQuantity = 0,
    this.claimedCount = 0,
    this.remaining = 0,
    this.limited = false,
    this.soldOut = false,
  });

  bool get isActive => active ?? true;

  /// Whether a buyer could still take one right now.
  bool get isClaimable =>
      isActive && !soldOut && DateTime.now().isBefore(expiresAt);

  bool get isManual => manual ?? false;

  factory Voucher.fromJson(Map<String, Object?> json) {
    return Voucher(
      id: (json['voucherId'] ?? json['id']) as String,
      code: json['code'] as String,
      title: json['title'] as String,
      shopId: json['shopId'] as String,
      discountValue: (json['discountValue'] as num).toInt(),
      isPercent: json['isPercent'] as bool,
      minSpend: (json['minSpend'] as num).toInt(),
      expiresAt: dateTime(json['expiresAt']),
      active: json['active'] as bool? ?? true,
      manual: json['manual'] as bool? ?? false,
      note: json['note'] as String? ?? '',
      codeFormat: json['codeFormat'] as String? ?? 'QR',
      totalQuantity: (json['totalQuantity'] as num?)?.toInt() ?? 0,
      claimedCount: (json['claimedCount'] as num?)?.toInt() ?? 0,
      remaining: (json['remaining'] as num?)?.toInt() ?? 0,
      limited: json['limited'] == true,
      soldOut: json['soldOut'] == true,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'code': code,
    'title': title,
    'shopId': shopId,
    'discountValue': discountValue,
    'isPercent': isPercent,
    'minSpend': minSpend,
    'expiresAt': expiresAt.toIso8601String(),
    'active': active,
    'manual': manual,
    'note': note,
    'codeFormat': codeFormat,
  };
}
