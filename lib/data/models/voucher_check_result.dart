import 'voucher.dart';

class VoucherCheckResult {
  final Voucher? voucher;
  final bool valid;
  final String message;
  final int discountAmount;
  final int finalPrice;

  const VoucherCheckResult({
    required this.voucher,
    required this.valid,
    required this.message,
    required this.discountAmount,
    required this.finalPrice,
  });
}
