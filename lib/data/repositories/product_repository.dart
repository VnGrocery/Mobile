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

  /// Creates or updates one product.
  ///
  /// [changeReason] is required by the server on every update: the edit is
  /// signed with that sentence inside it and shows up in the product's change
  /// log, which is the whole reason a shopper can trust the listing.
  Future<Product> saveRemote(
    Product product, {
    bool create = true,
    String changeReason = '',
  }) async {
    final remote = _remote;
    if (remote == null) {
      add(product);
      return product;
    }
    final item = await remote.saveProduct(
      product,
      create: create,
      changeReason: changeReason,
    );
    _replace(item);
    return item;
  }

  /// Removes a product, with the reason signed alongside it. The record of it
  /// having existed stays in the log; only the listing goes.
  Future<void> deleteRemote(Product product, String changeReason) async {
    final remote = _remote;
    if (remote == null) {
      _db.products.removeWhere((item) => item.id == product.id);
      return;
    }
    await remote.deleteProduct(
      shopId: product.shopId,
      productId: product.id,
      expectedVersion: product.version,
      changeReason: changeReason,
    );
    _db.products.removeWhere((item) => item.id == product.id);
  }

  void _replace(Product product) {
    final index = _db.products.indexWhere((item) => item.id == product.id);
    if (index < 0) {
      _db.products.add(product);
    } else {
      _db.products[index] = product;
    }
  }

  RemoteDataSource? get remote => _remote;
}
