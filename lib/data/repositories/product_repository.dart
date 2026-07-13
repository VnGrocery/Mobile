import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';

class ProductRepository {
  final MockDb _db;
  final RemoteDataSource? _remote;

  const ProductRepository(this._db, [this._remote]);

  List<Product> all({String? shopId}) {
    final products = shopId == null || shopId.isEmpty
        ? _db.products
        : _db.productsOfShop(shopId);
    return List.unmodifiable(products);
  }

  Product? byIdOrNull(String id) => _db.productByIdOrNull(id);

  Product byId(String id) => _db.productById(id);

  void add(Product product) => _db.addProduct(product);

  Future<List<Product>> refreshShop(
    String shopId, {
    bool seller = false,
  }) async {
    final remote = _remote;
    if (remote == null) return all(shopId: shopId);
    final items = await remote.products(shopId, seller: seller);
    _db.products.removeWhere((item) => item.shopId == shopId);
    _db.products.addAll(items);
    return List.unmodifiable(items);
  }

  Future<Product> fetch(String shopId, String productId) async {
    final remote = _remote;
    if (remote == null) return byId(productId);
    final item = await remote.product(shopId, productId);
    _replace(item);
    return item;
  }

  Future<Product> saveRemote(Product product) async {
    final remote = _remote;
    if (remote == null) {
      add(product);
      return product;
    }
    final item = await remote.saveProduct(product);
    _replace(item);
    return item;
  }

  void _replace(Product product) {
    final index = _db.products.indexWhere((item) => item.id == product.id);
    if (index < 0) {
      _db.products.add(product);
    } else {
      _db.products[index] = product;
    }
  }
}
