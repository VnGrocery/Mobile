import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories/seller_repository.dart';

const _shopId = 'shop-under-test';

Shop _shop() => Shop(
  id: _shopId,
  name: 'Rau Cô Ba',
  address: 'Chợ Bến Thành',
  rating: 4.5,
  reviewCount: 3,
  description: '',
  latitude: 10.77,
  longitude: 106.70,
);

Product _product(String id) => Product(
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
  status: 'published',
);

PledgeHistoryItem _pledge(String time) => PledgeHistoryItem(
  time: time,
  title: 'Ghi nhận',
  description: '',
  isVerified: true,
);

void main() {
  final db = MockDb.instance;

  setUp(() {
    db.shops
      ..clear()
      ..add(_shop());
    db.products
      ..clear()
      ..add(_product('p1'));
    db.pledgesByProduct.clear();
  });

  tearDown(db.resetForTesting);

  test('counts the records made today, whatever today is', () {
    // This was `time.startsWith('2026-05-30')` - a date written into the
    // source - so the tile read 0 on every day of the year except one.
    final today = DateTime(2027, 3, 14, 9);
    db.pledgesByProduct['p1'] = [
      _pledge(DateTime(2027, 3, 14, 8).toUtc().toIso8601String()),
      _pledge(DateTime(2027, 3, 14, 1).toUtc().toIso8601String()),
      _pledge(DateTime(2027, 3, 13, 23).toUtc().toIso8601String()),
    ];

    final dashboard = SellerRepository(db, now: () => today).dashboard(_shopId);

    expect(dashboard?.pledgesToday, 2);
    expect(dashboard?.pledges, hasLength(3));
  });

  test('a record made this evening counts today, not tomorrow', () {
    // The timestamps are UTC and the shopkeeper is not. Comparing the UTC date
    // directly pushes anything recorded after 07:00 in Vietnam onto the next
    // day's tally.
    final tonight = DateTime(2027, 3, 14, 23, 30);
    db.pledgesByProduct['p1'] = [_pledge(tonight.toUtc().toIso8601String())];

    final dashboard = SellerRepository(
      db,
      now: () => tonight,
    ).dashboard(_shopId);

    expect(dashboard?.pledgesToday, 1);
  });

  test('an unreadable timestamp is not counted', () {
    db.pledgesByProduct['p1'] = [_pledge('not a date')];

    final dashboard = SellerRepository(
      db,
      now: DateTime.now,
    ).dashboard(_shopId);

    expect(dashboard?.pledgesToday, 0);
  });

  test('a shop that is not cached has no dashboard', () {
    // It used to fall back to a hardcoded demo shop id that does not exist in
    // real data, and threw "Shop not found" instead of saying it had nothing.
    final seller = SellerRepository(db, now: DateTime.now);

    expect(seller.dashboard('nobody'), isNull);
    expect(seller.dashboard(null), isNull);
    expect(seller.dashboard(''), isNull);
  });
}
