import '../mock_data.dart';
import '../models.dart';

class ProductRepository {
  final MockDb _db;

  const ProductRepository(this._db);

  List<Product> all({String? shopId}) {
    final products = shopId == null || shopId.isEmpty
        ? _db.products
        : _db.productsOfShop(shopId);
    return List.unmodifiable(products);
  }

  Product byId(String id) => _db.productById(id);

  void add(Product product) => _db.addProduct(product);
}
