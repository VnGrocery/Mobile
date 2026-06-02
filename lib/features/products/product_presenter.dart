import '../../data/models.dart';
import '../../data/repositories.dart';

class ProductPresenter {
  const ProductPresenter._();

  static final AppRepositories _repos = AppRepositories.instance;

  static Product product(String productId) {
    return _repos.products.byId(productId);
  }
}
