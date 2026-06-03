import 'package:vngrocery/data/repositories/seller_dashboard.dart';

class SellerDashboardState {
  final SellerDashboard? dashboard;

  const SellerDashboardState({this.dashboard});

  bool get hasDashboard => dashboard != null;

  bool get canCreatePledge {
    return dashboard?.products.isNotEmpty ?? false;
  }
}
