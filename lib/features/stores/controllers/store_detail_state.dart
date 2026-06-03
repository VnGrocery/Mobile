import 'package:vngrocery/data/models.dart';

class StoreDetailState {
  final Shop? shop;
  final List<Product> products;
  final List<Review> reviews;

  const StoreDetailState({
    this.shop,
    this.products = const [],
    this.reviews = const [],
  });

  bool get hasShop => shop != null;

  Product? get latestProduct => products.isEmpty ? null : products.first;
}
