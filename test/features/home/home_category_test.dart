import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/controllers/home_state.dart';

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

RecommendedProduct _ranked(String id, String category, {String name = ''}) =>
    RecommendedProduct(
      productId: id,
      shopId: _shop.id,
      shopName: _shop.name,
      name: name.isEmpty ? 'p$id' : name,
      category: category,
      price: 1000,
    );

/// The chips and the grid both read the ranked catalogue, so that is what a
/// state under test has to carry.
HomeState _state(List<RecommendedProduct> products) =>
    HomeState(recommendations: Recommendations(products: products));

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
        _ranked('1', 'fresh_produce'),
        _ranked('2', 'meat'),
        _ranked('3', 'fresh_produce'),
      ]);

      expect(state.categories, ['fresh_produce', 'meat']);
    });

    test('ignore products with no category', () {
      final state = _state([_ranked('1', 'fresh_produce'), _ranked('2', '  ')]);

      expect(state.categories, ['fresh_produce']);
    });

    test('are empty when nothing is categorised, so the row can hide', () {
      expect(_state([_ranked('1', '')]).categories, isEmpty);
      expect(const HomeState().categories, isEmpty);
    });

    test('selecting one narrows the grid', () {
      final state = _state([
        _ranked('1', 'fresh_produce'),
        _ranked('2', 'meat'),
        _ranked('3', 'fresh_produce'),
      ]);

      expect(
        state.rankedGrid(category: 'fresh_produce').map((p) => p.productId),
        ['1', '3'],
      );
      expect(state.rankedGrid(category: 'meat').map((p) => p.productId), ['2']);
    });

    test('a category with no products yields an empty grid', () {
      final state = _state([_ranked('1', 'fresh_produce')]);

      expect(state.rankedGrid(category: 'seafood'), isEmpty);
    });

    test('search matches the product name and the shop name', () {
      final state = _state([
        _ranked('1', 'fresh_produce', name: 'Cải ngọt Đà Lạt'),
        _ranked('2', 'meat', name: 'Thịt ba chỉ'),
      ]);

      expect(state.rankedGrid(query: 'cải').map((p) => p.productId), ['1']);
      expect(state.rankedGrid(query: 'Shop').map((p) => p.productId), [
        '1',
        '2',
      ]);
      expect(state.rankedGrid(query: 'không có gì'), isEmpty);
    });

    test('the spotlight and the grid never print the same product twice', () {
      final products = [
        for (var i = 0; i < 9; i++) _ranked('$i', 'fresh_produce'),
      ];
      final state = _state(products);

      final spotlight = state.spotlightProducts.map((p) => p.productId);
      final grid = state.rankedGrid().map((p) => p.productId);

      expect(spotlight, ['0', '1', '2', '3', '4', '5']);
      expect(grid, ['6', '7', '8']);
      expect(spotlight.toSet().intersection(grid.toSet()), isEmpty);
    });

    test('filtering collapses the split so no match is hidden', () {
      final products = [
        for (var i = 0; i < 9; i++) _ranked('$i', 'fresh_produce'),
      ];
      final state = _state(products);

      // Carving a spotlight out of the reader's own search results would drop
      // the six strongest matches off the screen entirely.
      expect(state.rankedGrid(category: 'fresh_produce').length, 9);
    });
  });
}
