import '../../data/data_hooks.dart';
import '../../data/models.dart';

class ExplorePresenter {
  const ExplorePresenter._();

  static const filters = [
    'Đánh giá tốt',
    'Có ghi nhận',
    'Gần bạn',
    'Mới nhất',
  ];

  static List<Shop> shops() {
    return AppDataHooks.instance.getShops();
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
