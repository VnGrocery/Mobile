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
  });

  bool get isActive => active ?? true;

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
