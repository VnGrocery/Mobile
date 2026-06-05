import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/data_hooks.dart';
import 'package:vngrocery/utils/format.dart';

class VoucherPresenter {
  const VoucherPresenter._();

  static final AppDataHooks _data = AppDataHooks.instance;

  static List<UserVoucher> wallet(String userEmail) {
    return _data.getUserVouchers(userEmail);
  }

  static List<UserVoucher> visibleWallet(
    List<UserVoucher> wallet, {
    required bool showUsed,
  }) {
    return wallet.where((item) => showUsed || !item.isUsed).toList();
  }

  static int usableCount(List<UserVoucher> wallet) {
    return wallet.where((item) => !item.isUsed).length;
  }

  static Voucher voucher(String voucherId) {
    return _data.getVoucher(voucherId);
  }

  static UserVoucher userVoucher(String userVoucherId) {
    return _data.getUserVoucher(userVoucherId);
  }

  static Shop shop(String shopId) {
    return _data.getShop(shopId);
  }

  static bool useUserVoucher(String userVoucherId) {
    return _data.useUserVoucher(userVoucherId);
  }

  static List<Shop> shops() {
    return _data.getShops();
  }

  static UserVoucher addManualVoucher({
    required String userEmail,
    required String shopId,
    required String code,
    required String title,
    required String note,
    required String codeFormat,
    required DateTime expiresAt,
  }) {
    return _data.addManualVoucherToWallet(
      userEmail: userEmail,
      shopId: shopId,
      code: code,
      title: title,
      note: note,
      codeFormat: codeFormat,
      expiresAt: expiresAt,
    );
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
