import '../../data/models.dart';
import '../../data/repositories.dart';

class SellerShopPresenter {
  const SellerShopPresenter._();

  static final AppRepositories _repos = AppRepositories.instance;

  static const demoShopId = 's1';

  static String effectiveShopId(String? shopId) {
    return shopId ?? demoShopId;
  }

  static Shop shop(String? shopId) {
    return _repos.shops.byId(effectiveShopId(shopId));
  }

  static SellerDashboard dashboard(String? shopId) {
    return _repos.seller.dashboard(shopId);
  }

  static Shop saveShop({
    required String? shopId,
    required String name,
    required String description,
    required String address,
  }) {
    return _repos.shops.save(
      shopId: effectiveShopId(shopId),
      name: name.trim(),
      description: description.trim(),
      address: address.trim(),
    );
  }
}
