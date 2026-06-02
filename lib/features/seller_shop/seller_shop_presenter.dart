import '../../data/data_hooks.dart';
import '../../data/models.dart';

class SellerShopPresenter {
  const SellerShopPresenter._();

  static const demoShopId = 's1';

  static String effectiveShopId(String? shopId) {
    return shopId ?? demoShopId;
  }

  static Shop shop(String? shopId) {
    return AppDataHooks.instance.getShop(effectiveShopId(shopId));
  }

  static SellerDashboard dashboard(String? shopId) {
    return AppDataHooks.instance.getSellerDashboard(shopId);
  }

  static Shop saveShop({
    required String? shopId,
    required String name,
    required String description,
    required String address,
  }) {
    return AppDataHooks.instance.saveShop(
      shopId: effectiveShopId(shopId),
      name: name.trim(),
      description: description.trim(),
      address: address.trim(),
    );
  }
}
