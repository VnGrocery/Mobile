import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'buyer_check_state.dart';

class BuyerCheckCubit extends Cubit<BuyerCheckState> with CloseSafeEmit {
  final AppRepositories _repositories;

  BuyerCheckCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(const BuyerCheckState());

  void loadDemoResult() {
    final result = _repositories.buyerChecks.lastResult;
    final productId = _repositories.buyerChecks.lastProductId;
    final product = productId == null
        ? _repositories.products.all().firstOrNull
        : _repositories.products.byId(productId);
    if (product == null) return;
    final shop = _repositories.shops.byId(product.shopId);
    emit(BuyerCheckState(result: result, product: product, shop: shop));
  }

  void checkVoucher(String code) {
    final product = state.product;
    if (product == null) return;
    emit(
      state.copyWith(
        voucherResult: _repositories.vouchers.check(
          code: code,
          shopId: product.shopId,
          orderValue: product.price,
        ),
      ),
    );
  }

  Future<void> checkVoucherRemote(String code) async {
    final product = state.product;
    if (product == null) return;
    emit(
      state.copyWith(
        voucherResult: await _repositories.vouchers.checkRemote(
          code: code,
          shopId: product.shopId,
          orderValue: product.price,
        ),
      ),
    );
  }

  UserVoucher saveVoucherToWallet({
    required String userEmail,
    required Voucher voucher,
  }) {
    return _repositories.vouchers.saveToWallet(
      userEmail: userEmail,
      voucherId: voucher.id,
    );
  }

  Future<UserVoucher> saveVoucherToWalletRemote({
    required String userEmail,
    required Voucher voucher,
  }) => _repositories.vouchers.saveToWalletRemote(
    userEmail: userEmail,
    voucherId: voucher.id,
  );
}
