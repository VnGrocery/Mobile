import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/home_presenter.dart';

class HomeState {
  final List<Shop> shops;
  final List<Product> products;
  final List<HomePledgeItem> pledgeItems;

  const HomeState({
    this.shops = const [],
    this.products = const [],
    this.pledgeItems = const [],
  });

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
