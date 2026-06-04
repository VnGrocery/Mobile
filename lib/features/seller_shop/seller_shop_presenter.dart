import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/data_hooks.dart';

class SellerShopPresenter {
  const SellerShopPresenter._();

  static final AppDataHooks _data = AppDataHooks.instance;

  static const demoShopId = 's1';

  static String effectiveShopId(String? shopId) {
    return shopId ?? demoShopId;
  }

  static Shop shop(String? shopId) {
    return _data.getShop(effectiveShopId(shopId));
  }

  static SellerDashboard dashboard(String? shopId) {
    return _data.getSellerDashboard(shopId);
  }

  static Shop saveShop({
    required String? shopId,
    required String name,
    required String description,
    required String address,
  }) {
    return _data.saveShop(
      shopId: effectiveShopId(shopId),
      name: name.trim(),
      description: description.trim(),
      address: address.trim(),
    );
  }
}
