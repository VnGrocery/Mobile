import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/home_presenter.dart';

/// Where the home tab is in its load.
///
/// The cubit used to swallow every error, so a server that was unreachable
/// looked exactly like a server with nothing in it: a blank page, forever, with
/// no way to retry.
enum HomeStatus { loading, ready, failed }

class HomeState {
  final HomeStatus status;
  final List<Shop> shops;
  final List<Product> products;
  final List<HomePledgeItem> pledgeItems;

  const HomeState({
    this.status = HomeStatus.loading,
    this.shops = const [],
    this.products = const [],
    this.pledgeItems = const [],
  });

  /// Nothing to show: no shops worth ranking and no recent checks.
  bool get isEmpty => shops.isEmpty && pledgeItems.isEmpty;

  /// Categories actually present in the loaded products.
  ///
  /// Derived rather than hardcoded: the previous fixed list of meat types
  /// matched neither the sample data ("Thịt gà") nor the server, which sends
  /// keys like "fresh_produce", so a filter built on it could only ever return
  /// nothing.
  List<String> get categories {
    final seen = <String>{};
    for (final item in pledgeItems) {
      final category = item.product.category.trim();
      if (category.isNotEmpty) seen.add(category);
    }
    final list = seen.toList()..sort();
    return list;
  }

  /// Shops worth putting under "đánh giá tốt", best first.
  ///
  /// The section used to render [shops] in whatever order the server returned,
  /// so a brand-new shop with 0.0 stars and no reviews sat at the front of a
  /// list titled "top rated". A shop earns a place here only once it has a
  /// signal to rank on — a review, or a trust verdict backed by real pledges —
  /// and the list is empty
  /// when none do, which lets the section hide itself.
  List<Shop> get topRatedShops {
    final ranked = shops
        .where(
          (shop) =>
              shop.reviewCount > 0 || (shop.trustSummary?.hasData ?? false),
        )
        .toList();
    ranked.sort((a, b) {
      final byRating = b.rating.compareTo(a.rating);
      if (byRating != 0) return byRating;
      final byTrust = _trustScore(b).compareTo(_trustScore(a));
      if (byTrust != 0) return byTrust;
      return b.reviewCount.compareTo(a.reviewCount);
    });
    return ranked;
  }

  static double _trustScore(Shop shop) => shop.trustSummary?.score ?? 0;

  /// Recent checks, optionally narrowed to one category.
  List<HomePledgeItem> featuredPledgeItems({int limit = 3, String? category}) {
    final items = category == null || category.isEmpty
        ? pledgeItems
        : pledgeItems
              .where((item) => item.product.category == category)
              .toList();
    return items.take(limit).toList();
  }
}
