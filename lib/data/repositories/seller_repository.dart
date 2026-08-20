import 'package:vngrocery/data/app_data_config.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'seller_dashboard.dart';

class SellerRepository {
  final MockDb _db;

  const SellerRepository(this._db);

  SellerDashboard dashboard(String? shopId) {
    final selectedShopId = shopId == null || shopId.isEmpty
        ? AppDataConfig.demoShopId
        : shopId;
    final shop = _db.shopById(selectedShopId);
    final products = _db.productsOfShop(shop.id);
    final pledges = products.expand((p) => _db.pledgesOf(p.id)).toList();
    final pledgesToday = pledges
        .where((p) => p.time.startsWith('2026-05-30'))
        .length;

    return SellerDashboard(
      shop: shop,
      products: List.unmodifiable(products),
      pledges: List.unmodifiable(pledges),
      pledgesToday: pledgesToday,
      warningCount: products.where((p) => p.freshnessScore < 6).length,
      trustGrade: _trustGrade(shop.rating),
    );
  }

  String _trustGrade(double rating) {
    if (rating >= 4.7) return 'A';
    if (rating >= 4.3) return 'B';
    if (rating > 0) return 'C';
    return 'N/A';
  }
}
