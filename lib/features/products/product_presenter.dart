import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';

class ProductPresenter {
  const ProductPresenter._();

  static final AppRepositories _repos = AppRepositories.instance;

  static Product product(String productId) {
    return _repos.products.byId(productId);
  }
}
