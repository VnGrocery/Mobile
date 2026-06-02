import '../mock_data.dart';
import '../models.dart';

class VoucherRepository {
  final MockDb _db;

  const VoucherRepository(this._db);

  Voucher byId(String voucherId) => _db.voucherById(voucherId);

  UserVoucher userVoucherById(String userVoucherId) {
    return _db.userVoucherById(userVoucherId);
  }

  List<UserVoucher> wallet(String userEmail) {
    return List.unmodifiable(_db.userVoucherWallet(userEmail));
  }

  VoucherCheckResult check({
    required String code,
    required String shopId,
    required int orderValue,
  }) {
    return _db.checkVoucher(
      code: code,
      shopId: shopId,
      orderValue: orderValue,
    );
  }

  UserVoucher saveToWallet({
    required String userEmail,
    required String voucherId,
  }) {
    return _db.saveVoucherToWallet(
      userEmail: userEmail,
      voucherId: voucherId,
    );
  }

  UserVoucher addManualToWallet({
    required String userEmail,
    required String shopId,
    required String code,
    required String title,
    required String note,
    required String codeFormat,
    required DateTime expiresAt,
  }) {
    return _db.addManualVoucherToWallet(
      userEmail: userEmail,
      shopId: shopId,
      code: code,
      title: title,
      note: note,
      codeFormat: codeFormat,
      expiresAt: expiresAt,
    );
  }

  void useUserVoucher(String userVoucherId) {
    _db.useUserVoucher(userVoucherId);
  }
}
