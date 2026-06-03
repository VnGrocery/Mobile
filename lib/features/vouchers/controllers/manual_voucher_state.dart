import '../../../data/models.dart';

class ManualVoucherState {
  final List<Shop> shops;
  final String? shopId;
  final String codeFormat;
  final DateTime expiresAt;
  final bool saved;

  const ManualVoucherState({
    this.shops = const [],
    this.shopId,
    this.codeFormat = 'QR',
    required this.expiresAt,
    this.saved = false,
  });

  factory ManualVoucherState.initial() {
    return ManualVoucherState(
      expiresAt: DateTime(2026, 6, 30, 23, 59),
    );
  }

  ManualVoucherState copyWith({
    List<Shop>? shops,
    String? shopId,
    String? codeFormat,
    DateTime? expiresAt,
    bool? saved,
  }) {
    return ManualVoucherState(
      shops: shops ?? this.shops,
      shopId: shopId ?? this.shopId,
      codeFormat: codeFormat ?? this.codeFormat,
      expiresAt: expiresAt ?? this.expiresAt,
      saved: saved ?? this.saved,
    );
  }
}
