import 'package:vngrocery/data/models.dart';

class BuyerCheckState {
  final BuyerCheckResult? result;
  final Product? product;
  final Shop? shop;
  final VoucherCheckResult? voucherResult;

  const BuyerCheckState({
    this.result,
    this.product,
    this.shop,
    this.voucherResult,
  });

  bool get hasData => result != null && product != null && shop != null;

  BuyerCheckState copyWith({
    BuyerCheckResult? result,
    Product? product,
    Shop? shop,
    VoucherCheckResult? voucherResult,
  }) {
    return BuyerCheckState(
      result: result ?? this.result,
      product: product ?? this.product,
      shop: shop ?? this.shop,
      voucherResult: voucherResult ?? this.voucherResult,
    );
  }
}
