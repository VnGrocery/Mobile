import 'package:vngrocery/data/models.dart';

class VoucherWalletState {
  final List<UserVoucher> wallet;
  final bool showUsed;

  const VoucherWalletState({
    this.wallet = const [],
    this.showUsed = false,
  });

  List<UserVoucher> get visibleWallet {
    return wallet.where((item) => showUsed || !item.isUsed).toList();
  }

  int get usableCount => wallet.where((item) => !item.isUsed).length;

  VoucherWalletState copyWith({
    List<UserVoucher>? wallet,
    bool? showUsed,
  }) {
    return VoucherWalletState(
      wallet: wallet ?? this.wallet,
      showUsed: showUsed ?? this.showUsed,
    );
  }
}
