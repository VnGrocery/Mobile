import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';

class ReviewRepository {
  final MockDb _db;

  const ReviewRepository(this._db);

  List<Review> ofShop(String shopId) =>
      List.unmodifiable(_db.reviewsOf(shopId));
}
