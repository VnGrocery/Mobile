import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/products/controllers/product_detail_state.dart';
import 'package:vngrocery/data/models.dart';

final _product = Product(
  id: 'p1',
  shopId: 's1',
  name: 'Cải kale xoăn',
  description: '',
  category: 'vegetables',
  price: 69000,
  freshnessScore: 9,
  freshnessNote: '',
  tags: [],
  imageUrls: [],
  status: 'published',
);

const _shop = Shop(
  id: 's1',
  name: 'Rau Hữu Cơ Quận 3',
  address: 'addr',
  rating: 4.7,
  reviewCount: 3,
  description: '',
);

void main() {
  group('ProductDetailState.copyWith', () {
    test('keeps what the other loaders already put there', () {
      // The shop, the history and the proof arrive from three requests running
      // side by side; each must add to the state rather than replace it, or
      // whichever answers last wipes the other two.
      const history = ProductHistory(productId: 'p1', chainVerified: true);

      final state = ProductDetailState(product: _product)
          .copyWith(shop: _shop)
          .copyWith(history: history)
          .copyWith(loadingProof: false);

      expect(state.product?.id, 'p1');
      expect(state.shop?.name, 'Rau Hữu Cơ Quận 3');
      expect(state.history?.chainVerified, isTrue);
    });

    test('an empty history is not treated as something to show', () {
      final state = ProductDetailState(
        product: _product,
        history: const ProductHistory(productId: 'p1'),
      );

      expect(state.hasHistory, isFalse);
    });

    test('hasHistory is true once there is a recorded change', () {
      final state = ProductDetailState(
        product: _product,
        history: const ProductHistory(
          productId: 'p1',
          entries: [
            ProductHistoryEntry(
              sha: 'abc123def',
              shortSha: 'abc123',
              sequence: 1,
              action: 'product.created',
            ),
          ],
        ),
      );

      expect(state.hasHistory, isTrue);
    });
  });
}
