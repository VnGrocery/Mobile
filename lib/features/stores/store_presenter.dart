import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/data_hooks.dart';

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

  static String shareText(Shop shop) {
    return '${shop.name}\n${shop.address}\n${shop.rating} điểm đánh giá - ${shop.reviewCount} lượt đánh giá';
  }
}
