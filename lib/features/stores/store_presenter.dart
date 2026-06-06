import 'package:vngrocery/data/data_hooks.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

class StorePresenter {
  const StorePresenter._();

  static final AppDataHooks _data = AppDataHooks.instance;

  static Shop shop(String shopId) {
    return _data.getShop(shopId);
  }

  static List<Product> products(String shopId) {
    return _data.getProducts(shopId: shopId);
  }

  static List<Review> reviews(String shopId) {
    return _data.getReviews(shopId);
  }

  static String shareText(Shop shop, AppLocalizations l10n) {
    return '${shop.name}\n${shop.address}\n${l10n.storeShareSummary(shop.rating.toString(), shop.reviewCount)}';
  }
}
