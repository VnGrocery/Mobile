import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/utils/format.dart';

class VoucherPresenter {
  const VoucherPresenter._();

  static bool useUserVoucher(
    String userVoucherId, {
    AppRepositories? repositories,
  }) {
    final repos = repositories ?? AppRepositories.instance;
    return repos.vouchers.useUserVoucher(userVoucherId);
  }

  static bool isExpired(Voucher voucher, {DateTime? now}) {
    return (now ?? DateTime.now()).isAfter(voucher.expiresAt);
  }

  static bool isDisabled(UserVoucher userVoucher, Voucher voucher) {
    return userVoucher.isUsed || isExpired(voucher) || !voucher.isActive;
  }

  static String discountLabel(Voucher voucher) {
    if (voucher.isManual) return voucher.codeFormat;
    if (voucher.isPercent) return 'Giảm ${voucher.discountValue}%';
    return 'Giảm ${formatVnd(voucher.discountValue)}';
  }

  static String spendLabel(Voucher voucher) {
    if (voucher.isManual) return 'Thông tin tự nhập';
    return 'Từ ${formatVnd(voucher.minSpend)}';
  }

  static String statusLabel(UserVoucher userVoucher, Voucher voucher) {
    if (userVoucher.isUsed) return 'Đã dùng';
    if (isExpired(voucher)) return 'Hết hạn';
    return 'Có thể dùng';
  }

  static String detailStatus(UserVoucher userVoucher, Voucher voucher) {
    if (userVoucher.isUsed) return 'Đã dùng';
    if (isExpired(voucher)) return 'Hết hạn';
    return 'Sẵn sàng sử dụng';
  }

  static String expiryLabel(Voucher voucher) {
    return 'HSD ${voucher.expiresAt.day}/${voucher.expiresAt.month}/${voucher.expiresAt.year}';
  }

  static String qrPayload({
    required UserVoucher userVoucher,
    required Voucher voucher,
    required Shop shop,
  }) {
    if (voucher.isManual) return voucher.code;
    return 'VNGROCERY:${userVoucher.id}:${voucher.code}:${shop.id}';
  }

  static String ruleDiscountLabel(Voucher voucher) {
    if (voucher.isManual) return 'Theo thông tin bạn tự nhập';
    return discountLabel(voucher);
  }
}
