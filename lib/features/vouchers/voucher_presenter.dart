import '../../data/data_hooks.dart';
import '../../data/models.dart';
import '../../utils/format.dart';

class VoucherPresenter {
  const VoucherPresenter._();

  static List<UserVoucher> wallet(String userEmail) {
    return AppDataHooks.instance.getUserVouchers(userEmail);
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
    return AppDataHooks.instance.getVoucher(voucherId);
  }

  static UserVoucher userVoucher(String userVoucherId) {
    return AppDataHooks.instance.getUserVoucher(userVoucherId);
  }

  static Shop shop(String shopId) {
    return AppDataHooks.instance.getShop(shopId);
  }

  static void useUserVoucher(String userVoucherId) {
    AppDataHooks.instance.useUserVoucher(userVoucherId);
  }

  static List<Shop> shops() {
    return AppDataHooks.instance.getShops();
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
    return AppDataHooks.instance.addManualVoucherToWallet(
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
