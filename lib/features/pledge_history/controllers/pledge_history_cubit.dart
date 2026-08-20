import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/repositories.dart';
import 'pledge_history_state.dart';

class PledgeHistoryCubit extends Cubit<PledgeHistoryState> {
  final AppRepositories _repositories;

  PledgeHistoryCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(const PledgeHistoryState());

  Future<void> load(String productId) async {
    final product = _repositories.products.byIdOrNull(productId);
    emit(
      PledgeHistoryState(
        history: _repositories.pledges.ofProduct(productId),
        shopId: product?.shopId ?? '',
      ),
    );
    if (product == null) return;
    try {
      final history = await _repositories.pledges.refresh(
        product.shopId,
        productId,
      );
      if (isClosed) return;
      emit(PledgeHistoryState(history: history, shopId: product.shopId));
    } catch (_) {}
  }
}
