import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/explore/controllers/explore_cubit.dart';
import 'package:vngrocery/features/explore/explore_presenter.dart';

Shop _shop({
  required String id,
  required String name,
  double rating = 0,
  bool hasPledges = false,
  double trustScore = 0,
  DateTime? createdAt,
}) {
  return Shop(
    id: id,
    name: name,
    address: 'addr $id',
    rating: rating,
    reviewCount: 0,
    description: '',
    createdAt: createdAt,
    trustSummary: TrustSummary(
      hasPledges: hasPledges,
      pledgeCount: hasPledges ? 1 : 0,
      score: trustScore,
    ),
  );
}

void main() {
  late AppRepositories repositories;

  setUp(() {
    // MockDb is a singleton; each test reseeds it so the cases stay isolated.
    final db = MockDb.instance;
    db.shops
      ..clear()
      ..addAll([
        _shop(
          id: 'a',
          name: 'Alpha',
          rating: 3,
          hasPledges: true,
          trustScore: 60,
          createdAt: DateTime(2026, 1, 1),
        ),
        _shop(
          id: 'b',
          name: 'Beta',
          rating: 5,
          trustScore: 90,
          createdAt: DateTime(2026, 6, 1),
        ),
        _shop(
          id: 'c',
          name: 'Gamma',
          rating: 1,
          hasPledges: true,
          trustScore: 80,
        ),
      ]);
    repositories = AppRepositories.forTesting(db);
  });

  ExploreCubit cubit() => ExploreCubit(repositories: repositories);

  test('top rated orders by rating', () async {
    final c = cubit();
    c.setFilter(ExploreFilters.topRated);

    expect(c.state.shops.map((s) => s.id), ['b', 'a', 'c']);
    await c.close();
  });

  test('recorded keeps only shops that have a pledge', () async {
    final c = cubit();
    c.setFilter(ExploreFilters.recorded);

    // Beta has no pledge, so it drops out entirely.
    expect(c.state.shops.map((s) => s.id), ['c', 'a']);
    await c.close();
  });

  test('newest orders by creation date, undated shops last', () async {
    final c = cubit();
    c.setFilter(ExploreFilters.newest);

    expect(c.state.shops.map((s) => s.id), ['b', 'a', 'c']);
    await c.close();
  });

  test('the search query still applies on top of a filter', () async {
    final c = cubit();
    c.setFilter(ExploreFilters.topRated);
    c.setQuery('alp');

    expect(c.state.shops.map((s) => s.id), ['a']);
    await c.close();
  });

  test('nearby leads the row, because distance decides where people buy', () {
    expect(ExploreFilters.keys.first, ExploreFilters.nearby);
    expect(ExploreFilters.keys, hasLength(4));
  });
}
