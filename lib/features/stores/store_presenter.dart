import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';

class StorePresenter {
  const StorePresenter._();

  static final AppRepositories _repos = AppRepositories.instance;

  static Shop shop(String shopId) {
    return _repos.shops.byId(shopId);
  }

  static List<Product> products(String shopId) {
    return _repos.products.all(shopId: shopId);
  }

  static List<Review> reviews(String shopId) {
    return _repos.reviews.ofShop(shopId);
  }

  static String shareText(Shop shop) {
    return '${shop.name}\n${shop.address}\n${shop.rating} điểm đánh giá - ${shop.reviewCount} lượt đánh giá';
  }
}
