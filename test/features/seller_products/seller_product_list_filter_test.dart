import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_products/controllers/seller_product_list_cubit.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';

const _shopId = 'shop-under-test';

Product _product(String id, String status) => Product(
  id: id,
  shopId: _shopId,
  name: 'Cải ngọt',
  description: '',
  category: 'vegetables',
  price: 18000,
  freshnessScore: 8,
  freshnessNote: '',
  tags: const [],
  imageUrls: const [],
  status: status,
);

void main() {
  final db = MockDb.instance;

  setUp(() {
    db.products
      ..clear()
      ..addAll([
        _product('p1', 'published'),
        // The spelling older cached rows and the fixture data carry.
        _product('p2', 'Published'),
        _product('p3', 'draft'),
      ]);
  });

  tearDown(db.resetForTesting);

  SellerProductListCubit cubit() => SellerProductListCubit(
    shopId: _shopId,
    repositories: AppRepositories.forTesting(db, null),
  );

  test('the published filter finds the products the server calls published', () {
    // The filter compared against 'Published' with a capital P, a spelling no
    // product ever carries, so every tab but "all" came up empty.
    final subject = cubit()
      ..setStateFilter(SellerProductPresenter.publishedState);

    expect(subject.state.products.map((product) => product.id), ['p1', 'p2']);

    subject.close();
  });

  test('the draft filter finds drafts', () {
    final subject = cubit()..setStateFilter(SellerProductPresenter.draftState);

    expect(subject.state.products.map((product) => product.id), ['p3']);

    subject.close();
  });

  test('all still means all', () {
    final subject = cubit()..setStateFilter(SellerProductPresenter.allState);

    expect(subject.state.products.length, 3);

    subject.close();
  });
}
