import '../mock_data.dart';
import '../models.dart';

class BuyerCheckRepository {
  final MockDb _db;

  const BuyerCheckRepository(this._db);

  BuyerCheckResult get lastResult => _db.lastBuyerCheck;
}
