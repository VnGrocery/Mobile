import 'package:vngrocery/data/repositories/seller_dashboard.dart';

class SellerDashboardPresenter {
  const SellerDashboardPresenter._();

  static bool canCreatePledge(SellerDashboard dashboard) {
    return dashboard.products.isNotEmpty;
  }
}
