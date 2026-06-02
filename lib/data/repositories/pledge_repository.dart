import '../mock_data.dart';
import '../models.dart';

class PledgeRepository {
  final MockDb _db;

  const PledgeRepository(this._db);

  List<PledgeHistoryItem> ofProduct(String productId) {
    return List.unmodifiable(_db.pledgesOf(productId));
  }

  void add(String productId, PledgeHistoryItem item) {
    _db.addPledge(productId, item);
  }
}
