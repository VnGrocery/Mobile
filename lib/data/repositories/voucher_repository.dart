import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';

class VoucherRepository {
  final MockDb _db;

  const VoucherRepository(this._db);

  Voucher? byIdOrNull(String voucherId) => _db.voucherByIdOrNull(voucherId);

  Voucher byId(String voucherId) => _db.voucherById(voucherId);

  UserVoucher? userVoucherByIdOrNull(String userVoucherId) {
    return _db.userVoucherByIdOrNull(userVoucherId);
  }

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

  bool useUserVoucher(String userVoucherId) {
    return _db.useUserVoucher(userVoucherId);
  }
}
