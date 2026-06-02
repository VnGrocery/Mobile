import '../../data/data_hooks.dart';

class SellerDashboardPresenter {
  const SellerDashboardPresenter._();

  static SellerDashboard dashboard(String? shopId) {
    return AppDataHooks.instance.getSellerDashboard(shopId);
  }

  static bool canCreatePledge(SellerDashboard dashboard) {
    return dashboard.products.isNotEmpty;
  }
}
