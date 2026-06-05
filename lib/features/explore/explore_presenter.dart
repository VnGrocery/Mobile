import 'package:vngrocery/data/data_hooks.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

class ExplorePresenter {
  const ExplorePresenter._();

  static final AppDataHooks _data = AppDataHooks.instance;

  static List<String> filters(AppLocalizations l10n) => [
    l10n.exploreFilterTopRated,
    l10n.exploreFilterRecorded,
    l10n.exploreFilterNearby,
    l10n.exploreFilterNewest,
  ];

  static List<Shop> shops() {
    return _data.getShops();
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
