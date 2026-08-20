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

Shop _shopWith({
  required String id,
  double rating = 0,
  int reviewCount = 0,
  TrustSummary? trust,
}) => Shop(
  id: id,
  name: 'Shop $id',
  address: 'addr',
  rating: rating,
  reviewCount: reviewCount,
  description: '',
  trustSummary: trust,
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
  group('top rated shops', () {
    test('drop shops with nothing to rank on', () {
      final state = HomeState(
        shops: [
          _shopWith(id: 'rated', rating: 4.5, reviewCount: 2),
          _shopWith(id: 'brand-new'),
        ],
      );

      expect(state.topRatedShops.map((s) => s.id), ['rated']);
    });

    test('a shop with a trust verdict but no review still qualifies', () {
      final state = HomeState(
        shops: [
          _shopWith(
            id: 'trusted',
            trust: const TrustSummary(
              score: 80,
              grade: TrustGrade.good,
              pledgeCount: 3,
              hasPledges: true,
            ),
          ),
        ],
      );

      expect(state.topRatedShops.map((s) => s.id), ['trusted']);
    });

    test('rank by rating, then by trust score', () {
      final state = HomeState(
        shops: [
          _shopWith(id: 'low', rating: 3, reviewCount: 1),
          _shopWith(id: 'high', rating: 5, reviewCount: 1),
          _shopWith(id: 'mid', rating: 4, reviewCount: 1),
        ],
      );

      expect(state.topRatedShops.map((s) => s.id), ['high', 'mid', 'low']);
    });

    test('a trust summary with no pledges is not a signal', () {
      // A brand new shop still comes back with a summary; it scores 0 because
      // there is no data, which is not the same as ranking last.
      final state = HomeState(
        shops: [_shopWith(id: 'empty', trust: const TrustSummary())],
      );

      expect(state.topRatedShops, isEmpty);
    });

    test('is empty when no shop has a signal, so the section can hide', () {
      expect(const HomeState().topRatedShops, isEmpty);
      expect(HomeState(shops: [_shopWith(id: 'a')]).topRatedShops, isEmpty);
    });
  });

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
      expect(produce.map((e) => e.item.product.id), ['1', '3']);

      final meat = state.featuredPledgeItems(category: 'meat');
      expect(meat.map((e) => e.item.product.id), ['2']);
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
