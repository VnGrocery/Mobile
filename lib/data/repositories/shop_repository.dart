import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/network/api_exception.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/app_data_config.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';

class ShopRepository {
  final MockDb _db;
  final RemoteDataSource? _remote;

  const ShopRepository(this._db, [this._remote]);

  List<Shop> all() => List.unmodifiable(_db.shops);

  Shop? byIdOrNull(String id) => _db.shopByIdOrNull(id);

  Shop byId(String id) => _db.shopById(id);

  /// Reloads the catalogue, narrowed to a circle around [near] when the app
  /// knows where the reader is.
  ///
  /// When that circle comes back empty the whole catalogue is fetched instead.
  /// The server filters at 20 km, so a reader outside every shop's radius would
  /// otherwise be handed nothing at all — and the app's own "here are the
  /// closest anyway" fallback has nothing to fall back to. Better a larger
  /// payload in the rare case than a blank app.
  Future<List<Shop>> refresh({String query = '', GeoPoint? near}) async {
    final remote = _remote;
    if (remote == null) return all();

    var items = await remote.shops(query: query, near: near);
    if (items.isEmpty && near != null && near.isSet) {
      items = await remote.shops(query: query);
    }

    _db.shops
      ..clear()
      ..addAll(items);
    // The catalogue is narrowed to a radius, so shops the reader has moved away
    // from disappear from this list. Their products were cached by an earlier,
    // wider fetch and nothing else clears them: `refreshShop` only replaces the
    // products of a shop it was asked about. Left behind they outlive their
    // shop, which both defeats the radius filter and breaks every screen that
    // joins a product back to the shop selling it.
    final known = items.map((shop) => shop.id).toSet();
    _db.products.removeWhere((product) => !known.contains(product.shopId));
    return all();
  }

  Future<Shop> fetch(String id) async {
    final remote = _remote;
    if (remote == null) return byId(id);
    final item = await remote.shop(id);
    _replace(item);
    return item;
  }

  /// The signed-in account's own shop, or null when it does not keep one.
  ///
  /// Only a 404 means "no shop". Everything else - the server down, no
  /// network, a bad token - is rethrown, because this used to swallow the lot
  /// and answer null: a seller with a flaky connection was told their shop did
  /// not exist and invited to create another one.
  Future<Shop?> fetchMine() async {
    final remote = _remote;
    if (remote == null) return _db.shops.firstOrNull;
    try {
      final item = await remote.myShop();
      _replace(item);
      return item;
    } on ApiException catch (error) {
      if (error.statusCode == 404) return null;
      rethrow;
    }
  }

  Shop save({
    required String shopId,
    required String name,
    required String description,
    required String address,
  }) {
    final index = _db.shops.indexWhere((shop) => shop.id == shopId);
    final updated = Shop(
      id: shopId,
      name: name,
      address: address,
      rating: index >= 0 ? _db.shops[index].rating : 0,
      reviewCount: index >= 0 ? _db.shops[index].reviewCount : 0,
      description: description,
      logoUrl: index >= 0 ? _db.shops[index].logoUrl : null,
    );
    if (index >= 0) {
      _db.shops[index] = updated;
    } else {
      _db.shops.add(updated);
    }
    return updated;
  }

  Future<Shop> saveRemote({
    required String? shopId,
    required String name,
    required String description,
    required String address,
    String changeReason = '',
  }) async {
    final remote = _remote;
    if (remote == null) {
      return save(
        shopId: shopId ?? AppDataConfig.demoShopId,
        name: name,
        description: description,
        address: address,
      );
    }
    final current = shopId == null ? null : byIdOrNull(shopId);
    final item = await remote.saveShop(
      changeReason: changeReason,
      id: current?.id,
      name: name,
      description: description,
      address: address,
      version: current?.version ?? 0,
      latitude: current?.latitude ?? 0,
      longitude: current?.longitude ?? 0,
    );
    _replace(item);
    return item;
  }

  void _replace(Shop shop) {
    final index = _db.shops.indexWhere((item) => item.id == shop.id);
    if (index < 0) {
      _db.shops.add(shop);
    } else {
      _db.shops[index] = shop;
    }
  }
}
