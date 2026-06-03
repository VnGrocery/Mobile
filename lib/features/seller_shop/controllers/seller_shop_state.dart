import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories/seller_dashboard.dart';

class SellerShopState {
  final Shop? shop;
  final SellerDashboard? dashboard;
  final bool saving;

  const SellerShopState({
    this.shop,
    this.dashboard,
    this.saving = false,
  });

  bool get hasShop => shop != null && dashboard != null;

  SellerShopState copyWith({
    Shop? shop,
    SellerDashboard? dashboard,
    bool? saving,
  }) {
    return SellerShopState(
      shop: shop ?? this.shop,
      dashboard: dashboard ?? this.dashboard,
      saving: saving ?? this.saving,
    );
  }
}
