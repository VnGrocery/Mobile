import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/repositories.dart';
import 'seller_dashboard_state.dart';

class SellerDashboardCubit extends Cubit<SellerDashboardState> {
  final AppRepositories _repositories;

  SellerDashboardCubit({AppRepositories? repositories})
      : _repositories = repositories ?? AppRepositories.instance,
        super(const SellerDashboardState());

  void load(String? shopId) {
    emit(SellerDashboardState(
        dashboard: _repositories.seller.dashboard(shopId)));
  }
}
