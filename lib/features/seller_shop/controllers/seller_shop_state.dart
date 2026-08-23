import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories/seller_dashboard.dart';

/// Why the shop profile screen is showing what it is showing.
///
/// A null shop used to mean all of "still loading", "this account has no shop
/// yet" and "the request failed", so the screen could only draw a spinner -
/// and for the last two nothing was ever going to arrive to stop it.
enum SellerShopStatus { loading, ready, noShop, failed }

class SellerShopState {
  final Shop? shop;
  final SellerDashboard? dashboard;
  final bool saving;
  final SellerShopStatus status;

  const SellerShopState({
    this.shop,
    this.dashboard,
    this.saving = false,
    this.status = SellerShopStatus.loading,
  });

  bool get hasShop => shop != null && dashboard != null;

  /// True while there is nothing to show and nothing to fill the form with.
  bool get isBusy => status == SellerShopStatus.loading && shop == null;

  /// The form doubles as the create-a-shop form, so it is editable with no
  /// shop behind it; only the summary card needs one.
  bool get isCreating => status == SellerShopStatus.noShop && shop == null;

  SellerShopState copyWith({
    Shop? shop,
    SellerDashboard? dashboard,
    bool? saving,
    SellerShopStatus? status,
  }) {
    return SellerShopState(
      shop: shop ?? this.shop,
      dashboard: dashboard ?? this.dashboard,
      saving: saving ?? this.saving,
      status: status ?? this.status,
    );
  }
}
