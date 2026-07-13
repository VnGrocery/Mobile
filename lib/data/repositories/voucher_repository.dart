import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';

class VoucherRepository {
  final MockDb _db;
  final RemoteDataSource? _remote;

  const VoucherRepository(this._db, [this._remote]);

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
      now: DateTime(2026, 5, 30),
    );
  }

  UserVoucher saveToWallet({
    required String userEmail,
    required String voucherId,
  }) {
    return _db.saveVoucherToWallet(userEmail: userEmail, voucherId: voucherId);
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

  Future<VoucherCheckResult> checkRemote({
    required String code,
    required String shopId,
    required int orderValue,
  }) async {
    final remote = _remote;
    if (remote == null) {
      return check(code: code, shopId: shopId, orderValue: orderValue);
    }
    final result = await remote.checkVoucher(code, shopId, orderValue);
    final voucher = result.voucher;
    if (voucher != null) _replaceVoucher(voucher);
    return result;
  }

  Future<List<UserVoucher>> refreshWallet(String userEmail) async {
    final remote = _remote;
    if (remote == null) return wallet(userEmail);
    final items = await remote.wallet();
    _db.userVouchers.clear();
    _db.userVouchers.addAll(
      items.map((item) {
        final userVoucher = UserVoucher(
          id: item.userVoucher.id,
          userEmail: userEmail,
          voucherId: item.userVoucher.voucherId,
          used: item.userVoucher.used,
          usedAt: item.userVoucher.usedAt,
        );
        _replaceVoucher(item.voucher);
        return userVoucher;
      }),
    );
    return wallet(userEmail);
  }

  Future<UserVoucher> saveToWalletRemote({
    required String userEmail,
    required String voucherId,
  }) async {
    final remote = _remote;
    if (remote == null) {
      return saveToWallet(userEmail: userEmail, voucherId: voucherId);
    }
    final item = await remote.saveVoucher(voucherId);
    _replaceVoucher(item.voucher);
    final userVoucher = UserVoucher(
      id: item.userVoucher.id,
      userEmail: userEmail,
      voucherId: item.userVoucher.voucherId,
      used: item.userVoucher.used,
      usedAt: item.userVoucher.usedAt,
    );
    _replaceUserVoucher(userVoucher);
    return userVoucher;
  }

  Future<UserVoucher> addManualToWalletRemote({
    required String userEmail,
    required String shopId,
    required String code,
    required String title,
    required String note,
    required String codeFormat,
    required DateTime expiresAt,
  }) async {
    final remote = _remote;
    if (remote == null) {
      return addManualToWallet(
        userEmail: userEmail,
        shopId: shopId,
        code: code,
        title: title,
        note: note,
        codeFormat: codeFormat,
        expiresAt: expiresAt,
      );
    }
    final item = await remote.manualVoucher(
      shopId: shopId,
      code: code,
      title: title,
      note: note,
      codeFormat: codeFormat,
      expiresAt: expiresAt,
    );
    _replaceVoucher(item.voucher);
    final userVoucher = UserVoucher(
      id: item.userVoucher.id,
      userEmail: userEmail,
      voucherId: item.userVoucher.voucherId,
      used: item.userVoucher.used,
      usedAt: item.userVoucher.usedAt,
    );
    _replaceUserVoucher(userVoucher);
    return userVoucher;
  }

  Future<bool> useUserVoucherRemote(String userVoucherId) async {
    final remote = _remote;
    if (remote == null) return useUserVoucher(userVoucherId);
    final item = await remote.useVoucher(userVoucherId);
    _replaceVoucher(item.voucher);
    final existing = userVoucherByIdOrNull(userVoucherId);
    _replaceUserVoucher(
      UserVoucher(
        id: item.userVoucher.id,
        userEmail: existing?.userEmail ?? '',
        voucherId: item.userVoucher.voucherId,
        used: item.userVoucher.used,
        usedAt: item.userVoucher.usedAt,
      ),
    );
    return true;
  }

  void _replaceVoucher(Voucher voucher) {
    final index = _db.vouchers.indexWhere((item) => item.id == voucher.id);
    if (index < 0) {
      _db.vouchers.add(voucher);
    } else {
      _db.vouchers[index] = voucher;
    }
  }

  void _replaceUserVoucher(UserVoucher voucher) {
    final index = _db.userVouchers.indexWhere((item) => item.id == voucher.id);
    if (index < 0) {
      _db.userVouchers.add(voucher);
    } else {
      _db.userVouchers[index] = voucher;
    }
  }
}
