import 'package:vngrocery/data/data_hooks.dart';

class SellerDashboardPresenter {
  const SellerDashboardPresenter._();

  static final AppDataHooks _data = AppDataHooks.instance;

  static SellerDashboard dashboard(String? shopId) {
    return _data.getSellerDashboard(shopId);
  }

  static bool canCreatePledge(SellerDashboard dashboard) {
    return dashboard.products.isNotEmpty;
  }
}
