import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/controllers/home_state.dart';
import 'package:vngrocery/features/home/home_presenter.dart';

Product _product(String id, String category) => Product(
  id: id,
  shopId: 's1',
  name: 'p$id',
  description: '',
  category: category,
  price: 1000,
  freshnessScore: 8,
  freshnessNote: '',
  tags: const [],
  imageUrls: const [],
  status: 'published',
);

const _shop = Shop(
  id: 's1',
  name: 'Shop',
  address: 'addr',
  rating: 0,
  reviewCount: 0,
  description: '',
);

HomeState _state(List<Product> products) {
  return HomeState(
    products: products,
    pledgeItems: [
      for (final p in products) HomePledgeItem(product: p, shop: _shop),
    ],
  );
}

void main() {
  group('home categories', () {
    test('are taken from the products on screen, sorted and deduplicated', () {
      final state = _state([
        _product('1', 'fresh_produce'),
        _product('2', 'meat'),
        _product('3', 'fresh_produce'),
      ]);

      expect(state.categories, ['fresh_produce', 'meat']);
    });

    test('ignore products with no category', () {
      final state = _state([
        _product('1', 'fresh_produce'),
        _product('2', '  '),
      ]);

      expect(state.categories, ['fresh_produce']);
    });

    test('are empty when nothing is categorised, so the row can hide', () {
      expect(_state([_product('1', '')]).categories, isEmpty);
      expect(const HomeState().categories, isEmpty);
    });

    test('selecting one narrows the recent checks', () {
      final state = _state([
        _product('1', 'fresh_produce'),
        _product('2', 'meat'),
        _product('3', 'fresh_produce'),
      ]);

      final produce = state.featuredPledgeItems(category: 'fresh_produce');
      expect(produce.map((i) => i.product.id), ['1', '3']);

      final meat = state.featuredPledgeItems(category: 'meat');
      expect(meat.map((i) => i.product.id), ['2']);
    });

    test('no selection shows everything, still capped by the limit', () {
      final state = _state([
        _product('1', 'a'),
        _product('2', 'b'),
        _product('3', 'c'),
        _product('4', 'd'),
      ]);

      expect(state.featuredPledgeItems().length, 3);
      expect(state.featuredPledgeItems(category: null).length, 3);
      expect(state.featuredPledgeItems(limit: 10).length, 4);
    });

    test('a category with no products yields an empty list', () {
      final state = _state([_product('1', 'fresh_produce')]);

      expect(state.featuredPledgeItems(category: 'seafood'), isEmpty);
    });
  });
}
