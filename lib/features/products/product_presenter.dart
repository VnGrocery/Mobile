import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/data_hooks.dart';

class ProductPresenter {
  const ProductPresenter._();

  static final AppDataHooks _data = AppDataHooks.instance;

  static Product product(String productId) {
    return _data.getProduct(productId);
  }
}
