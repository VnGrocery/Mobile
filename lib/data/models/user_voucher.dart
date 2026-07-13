import 'json_helpers.dart';

class UserVoucher {
  final String id;
  final String userEmail;
  final String voucherId;
  bool? used;
  DateTime? usedAt;

  UserVoucher({
    required this.id,
    required this.userEmail,
    required this.voucherId,
    this.used = false,
    this.usedAt,
  });

  bool get isUsed => used ?? false;

  factory UserVoucher.fromJson(Map<String, Object?> json) {
    return UserVoucher(
      id: (json['userVoucherId'] ?? json['id']) as String,
      userEmail: json['userEmail']?.toString() ?? '',
      voucherId: json['voucherId'] as String,
      used: json['used'] as bool? ?? false,
      usedAt: json['usedAt'] == null ? null : dateTime(json['usedAt']),
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'userEmail': userEmail,
    'voucherId': voucherId,
    'used': used,
    'usedAt': usedAt?.toIso8601String(),
  };
}
