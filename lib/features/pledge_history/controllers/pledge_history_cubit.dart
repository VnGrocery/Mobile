import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories.dart';
import 'pledge_history_state.dart';

class PledgeHistoryCubit extends Cubit<PledgeHistoryState> {
  final AppRepositories _repositories;

  PledgeHistoryCubit({AppRepositories? repositories})
      : _repositories = repositories ?? AppRepositories.instance,
        super(const PledgeHistoryState());

  void load(String productId) {
    emit(PledgeHistoryState(
        history: _repositories.pledges.ofProduct(productId)));
  }
}
