import '../../data/data_hooks.dart';
import '../../data/models.dart';

class HomePledgeItem {
  final Product product;
  final Shop shop;

  const HomePledgeItem({
    required this.product,
    required this.shop,
  });
}

class HomePresenter {
  const HomePresenter._();

  static List<Shop> shops() => AppDataHooks.instance.getShops();

  static List<Product> products() => AppDataHooks.instance.getProducts();

  static List<HomePledgeItem> pledgeItems() {
    final data = AppDataHooks.instance;
    return products()
        .map(
          (product) => HomePledgeItem(
            product: product,
            shop: data.getShop(product.shopId),
          ),
        )
        .toList();
  }

  static List<HomePledgeItem> featuredPledgeItems({int limit = 3}) {
    return pledgeItems().take(limit).toList();
  }
}
