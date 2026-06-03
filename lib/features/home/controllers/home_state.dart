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

  List<HomePledgeItem> featuredPledgeItems({int limit = 3}) {
    return pledgeItems.take(limit).toList();
  }
}
