import 'package:vngrocery/data/repositories/seller_dashboard.dart';

/// Why the dashboard is showing what it is showing.
///
/// A null dashboard used to mean all three of "still loading", "this account
/// has no shop" and "the request failed", so all three drew the same spinner
/// and two of them spun for ever.
enum SellerDashboardStatus { loading, ready, noShop, failed }

class SellerDashboardState {
  final SellerDashboard? dashboard;
  final SellerDashboardStatus status;

  const SellerDashboardState({
    this.dashboard,
    this.status = SellerDashboardStatus.loading,
  });

  bool get hasDashboard => dashboard != null;

  /// True while there is nothing to show yet. A refresh that fails after the
  /// dashboard has arrived leaves the old figures on screen rather than
  /// blanking them.
  bool get isBusy =>
      status == SellerDashboardStatus.loading && dashboard == null;

  bool get canCreatePledge => dashboard?.products.isNotEmpty ?? false;
}
