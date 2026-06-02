import '../../data/data_hooks.dart';
import '../../data/models.dart';

class ProductPresenter {
  const ProductPresenter._();

  static Product product(String productId) {
    return AppDataHooks.instance.getProduct(productId);
  }
}
