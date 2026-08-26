import 'package:vngrocery/data/models.dart';

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
    // Relative to today, not a fixed calendar date: a hardcoded date rots the
    // moment it passes, and every manual voucher saved without picking one
    // then fails server-side validation ("voucher is no longer available")
    // for a reason no error message on this screen explains.
    final in30Days = DateTime.now().add(const Duration(days: 30));
    return ManualVoucherState(
      expiresAt: DateTime(in30Days.year, in30Days.month, in30Days.day, 23, 59),
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
