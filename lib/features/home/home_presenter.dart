import '../../data/models.dart';
import '../../data/repositories.dart';

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

  static final AppRepositories _repos = AppRepositories.instance;

  static List<Shop> shops() => _repos.shops.all();

  static List<Product> products() => _repos.products.all();

  static List<HomePledgeItem> pledgeItems() {
    return products()
        .map(
          (product) => HomePledgeItem(
            product: product,
            shop: _repos.shops.byId(product.shopId),
          ),
        )
        .toList();
  }

  static List<HomePledgeItem> featuredPledgeItems({int limit = 3}) {
    return pledgeItems().take(limit).toList();
  }
}
