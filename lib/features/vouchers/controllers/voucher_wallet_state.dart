import 'package:vngrocery/data/models.dart';

class VoucherWalletState {
  final List<UserVoucher> wallet;
  final Map<String, Voucher> vouchersById;
  final Map<String, Shop> shopsById;
  final bool showUsed;

  const VoucherWalletState({
    this.wallet = const [],
    this.vouchersById = const {},
    this.shopsById = const {},
    this.showUsed = false,
  });

  List<UserVoucher> get visibleWallet {
    return wallet.where((item) => showUsed || !item.isUsed).toList();
  }

  int get usableCount => wallet.where((item) => !item.isUsed).length;

  Voucher? voucherOrNull(String voucherId) => vouchersById[voucherId];

  Shop? shopOrNull(String shopId) => shopsById[shopId];

  VoucherWalletState copyWith({
    List<UserVoucher>? wallet,
    Map<String, Voucher>? vouchersById,
    Map<String, Shop>? shopsById,
    bool? showUsed,
  }) {
    return VoucherWalletState(
      wallet: wallet ?? this.wallet,
      vouchersById: vouchersById ?? this.vouchersById,
      shopsById: shopsById ?? this.shopsById,
      showUsed: showUsed ?? this.showUsed,
    );
  }
}
