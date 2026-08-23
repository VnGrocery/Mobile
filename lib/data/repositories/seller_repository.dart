import 'package:vngrocery/data/mock_data.dart';
import 'seller_dashboard.dart';

class SellerRepository {
  final MockDb _db;

  /// Injectable so "today" can be pinned in a test.
  final DateTime Function() _now;

  SellerRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  /// The figures for one shop, or null when that shop is not in the cache.
  ///
  /// Used to fall back to a hardcoded demo shop id, which does not exist in
  /// real data, so the lookup threw "Shop not found" instead of admitting it
  /// had nothing to show.
  SellerDashboard? dashboard(String? shopId) {
    final id = shopId?.trim() ?? '';
    if (id.isEmpty) return null;
    final shop = _db.shopByIdOrNull(id);
    if (shop == null) return null;

    final products = _db.productsOfShop(shop.id);
    final pledges = products.expand((p) => _db.pledgesOf(p.id)).toList();

    return SellerDashboard(
      shop: shop,
      products: List.unmodifiable(products),
      pledges: List.unmodifiable(pledges),
      pledgesToday: pledges.where((p) => _isToday(p.time)).length,
      warningCount: products.where((p) => p.freshnessScore < 6).length,
      trustGrade: _trustGrade(shop.rating),
    );
  }

  /// Whether a recorded moment falls on today.
  ///
  /// This used to be `time.startsWith('2026-05-30')` - a date written into the
  /// source - so "records today" read 0 on every day but that one.
  ///
  /// The timestamps are UTC and the shopkeeper is not, so they are compared in
  /// local time: matching the UTC date directly would put an evening record on
  /// tomorrow's tally for anyone east of Greenwich, which is everyone here.
  bool _isToday(String time) {
    final at = DateTime.tryParse(time)?.toLocal();
    if (at == null) return false;
    final today = _now();
    return at.year == today.year &&
        at.month == today.month &&
        at.day == today.day;
  }

  String _trustGrade(double rating) {
    if (rating >= 4.7) return 'A';
    if (rating >= 4.3) return 'B';
    if (rating > 0) return 'C';
    // No rating yet is not a grade. The screens say so in words.
    return '';
  }
}
