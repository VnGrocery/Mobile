import 'package:vngrocery/core/location/geo.dart';
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
  Future<List<Shop>> refresh({String query = '', GeoPoint? near}) async {
    final remote = _remote;
    if (remote == null) return all();
    final items = await remote.shops(query: query, near: near);
    _db.shops
      ..clear()
      ..addAll(items);
    return all();
  }

  Future<Shop> fetch(String id) async {
    final remote = _remote;
    if (remote == null) return byId(id);
    final item = await remote.shop(id);
    _replace(item);
    return item;
  }

  Future<Shop?> fetchMine() async {
    final remote = _remote;
    if (remote == null) return _db.shops.firstOrNull;
    try {
      final item = await remote.myShop();
      _replace(item);
      return item;
    } catch (_) {
      return null;
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
