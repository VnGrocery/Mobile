import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'manual_voucher_state.dart';

class ManualVoucherCubit extends Cubit<ManualVoucherState> {
  final AppRepositories _repositories;

  ManualVoucherCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(ManualVoucherState.initial());

  Future<void> load() async {
    _emitShops();
    try {
      await _repositories.shops.refresh();
      _emitShops();
    } catch (_) {}
  }

  void _emitShops() {
    final shops = _repositories.shops.all();
    emit(
      state.copyWith(
        shops: shops,
        shopId: state.shopId ?? (shops.isEmpty ? null : shops.first.id),
      ),
    );
  }

  void selectShop(String? shopId) {
    if (shopId == null) return;
    emit(state.copyWith(shopId: shopId, saved: false));
  }

  void setCodeFormat(String format) {
    emit(state.copyWith(codeFormat: format, saved: false));
  }

  void setExpiry(DateTime date) {
    emit(
      state.copyWith(
        expiresAt: DateTime(date.year, date.month, date.day, 23, 59),
        saved: false,
      ),
    );
  }

  UserVoucher? save({
    required String userEmail,
    required String code,
    required String title,
    required String note,
  }) {
    final shopId = state.shopId;
    if (shopId == null) return null;
    final userVoucher = _repositories.vouchers.addManualToWallet(
      userEmail: userEmail,
      shopId: shopId,
      code: code,
      title: title,
      note: note,
      codeFormat: state.codeFormat,
      expiresAt: state.expiresAt,
    );
    emit(state.copyWith(saved: true));
    return userVoucher;
  }

  Future<UserVoucher?> saveRemote({
    required String userEmail,
    required String code,
    required String title,
    required String note,
  }) async {
    final shopId = state.shopId;
    if (shopId == null) return null;
    final item = await _repositories.vouchers.addManualToWalletRemote(
      userEmail: userEmail,
      shopId: shopId,
      code: code,
      title: title,
      note: note,
      codeFormat: state.codeFormat,
      expiresAt: state.expiresAt,
    );
    emit(state.copyWith(saved: true));
    return item;
  }
}
