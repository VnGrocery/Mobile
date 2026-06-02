import '../../data/data_hooks.dart';
import '../../data/models.dart';

class StorePresenter {
  const StorePresenter._();

  static Shop shop(String shopId) {
    return AppDataHooks.instance.getShop(shopId);
  }

  static List<Product> products(String shopId) {
    return AppDataHooks.instance.getProducts(shopId: shopId);
  }

  static List<Review> reviews(String shopId) {
    return AppDataHooks.instance.getReviews(shopId);
  }

  static String shareText(Shop shop) {
    return '${shop.name}\n${shop.address}\n${shop.rating} điểm đánh giá - ${shop.reviewCount} lượt đánh giá';
  }
}
