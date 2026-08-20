import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';

class ReviewRepository {
  final MockDb _db;
  final RemoteDataSource? _remote;

  const ReviewRepository(this._db, [this._remote]);

  List<Review> ofShop(String shopId) =>
      List.unmodifiable(_db.reviewsOf(shopId));

  Future<List<Review>> refresh(String shopId) async {
    final remote = _remote;
    if (remote == null) return ofShop(shopId);
    final items = await remote.reviews(shopId);
    _db.reviewsByShop[shopId] = items;
    return List.unmodifiable(items);
  }

  Future<Review> create(
    String shopId,
    int rating,
    String comment, {
    List<String> imageUrls = const [],
  }) async {
    final remote = _remote;
    if (remote == null) {
      final item = Review(
        id: _db.nextId(),
        // Same as the server payload: no name, so the UI labels it.
        userName: '',
        rating: rating,
        comment: comment,
        date: DateTime.now().toIso8601String(),
      );
      _db.reviewsByShop.putIfAbsent(shopId, () => []).insert(0, item);
      return item;
    }
    final item = await remote.createReview(
      shopId,
      rating,
      comment,
      imageUrls: imageUrls,
    );
    _db.reviewsByShop.putIfAbsent(shopId, () => []).insert(0, item);
    return item;
  }

  RemoteDataSource? get remote => _remote;
}
