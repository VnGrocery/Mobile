import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';

class ExplorePresenter {
  const ExplorePresenter._();

  static final AppRepositories _repos = AppRepositories.instance;

  static const filters = [
    'Đánh giá tốt',
    'Có ghi nhận',
    'Gần bạn',
    'Mới nhất',
  ];

  static List<Shop> shops() {
    return _repos.shops.all();
  }

  static List<Shop> filteredShops(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    return shops().where((shop) {
      if (normalizedQuery.isEmpty) return true;
      return shop.name.toLowerCase().contains(normalizedQuery) ||
          shop.address.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  static Shop? selectedShop(List<Shop> shops, String? selectedShopId) {
    if (selectedShopId == null) return null;
    return shops.where((shop) => shop.id == selectedShopId).firstOrNull;
  }
}
