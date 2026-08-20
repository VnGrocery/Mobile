import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
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

  static String discountLabel(AppLocalizations l10n, Voucher voucher) {
    if (voucher.isManual) return voucher.codeFormat;
    if (voucher.isPercent) {
      return l10n.voucherDiscountPercent(voucher.discountValue);
    }
    return l10n.voucherDiscountAmount(formatVnd(voucher.discountValue));
  }

  static String spendLabel(AppLocalizations l10n, Voucher voucher) {
    if (voucher.isManual) return l10n.voucherManualInfo;
    return l10n.voucherMinSpendFrom(formatVnd(voucher.minSpend));
  }

  static String statusLabel(
    AppLocalizations l10n,
    UserVoucher userVoucher,
    Voucher voucher,
  ) {
    if (userVoucher.isUsed) return l10n.voucherUsedShort;
    if (isExpired(voucher)) return l10n.voucherExpiredLabel;
    return l10n.voucherUsableLabel;
  }

  static String detailStatus(
    AppLocalizations l10n,
    UserVoucher userVoucher,
    Voucher voucher,
  ) {
    if (userVoucher.isUsed) return l10n.voucherUsedShort;
    if (isExpired(voucher)) return l10n.voucherExpiredLabel;
    return l10n.voucherReadyLabel;
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

  static String ruleDiscountLabel(AppLocalizations l10n, Voucher voucher) {
    if (voucher.isManual) return l10n.voucherPerYourInput;
    return discountLabel(l10n, voucher);
  }
}
