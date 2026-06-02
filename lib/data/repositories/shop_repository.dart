import '../mock_data.dart';
import '../models.dart';

class ShopRepository {
  final MockDb _db;

  const ShopRepository(this._db);

  List<Shop> all() => List.unmodifiable(_db.shops);

  Shop byId(String id) => _db.shopById(id);

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
}
