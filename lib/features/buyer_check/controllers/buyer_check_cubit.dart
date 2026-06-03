import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'buyer_check_state.dart';

class BuyerCheckCubit extends Cubit<BuyerCheckState> {
  final AppRepositories _repositories;

  BuyerCheckCubit({AppRepositories? repositories})
      : _repositories = repositories ?? AppRepositories.instance,
        super(const BuyerCheckState());

  void loadDemoResult() {
    final result = _repositories.buyerChecks.lastResult;
    final product = _repositories.products.byId('p1');
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

  UserVoucher saveVoucherToWallet({
    required String userEmail,
    required Voucher voucher,
  }) {
    return _repositories.vouchers.saveToWallet(
      userEmail: userEmail,
      voucherId: voucher.id,
    );
  }
}
