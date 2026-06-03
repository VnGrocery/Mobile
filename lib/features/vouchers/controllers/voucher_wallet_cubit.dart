import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/repositories.dart';
import 'voucher_wallet_state.dart';

class VoucherWalletCubit extends Cubit<VoucherWalletState> {
  final AppRepositories _repositories;
  final String _userEmail;

  VoucherWalletCubit({
    required String userEmail,
    AppRepositories? repositories,
  })  : _userEmail = userEmail,
        _repositories = repositories ?? AppRepositories.instance,
        super(const VoucherWalletState());

  void load() {
    emit(
      state.copyWith(
        wallet: _repositories.vouchers.wallet(_userEmail),
      ),
    );
  }

  void setShowUsed(bool value) {
    emit(state.copyWith(showUsed: value));
  }
}
