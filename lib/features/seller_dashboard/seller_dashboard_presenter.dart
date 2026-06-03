import 'package:vngrocery/data/repositories.dart';

class SellerDashboardPresenter {
  const SellerDashboardPresenter._();

  static final AppRepositories _repos = AppRepositories.instance;

  static SellerDashboard dashboard(String? shopId) {
    return _repos.seller.dashboard(shopId);
  }

  static bool canCreatePledge(SellerDashboard dashboard) {
    return dashboard.products.isNotEmpty;
  }
}
