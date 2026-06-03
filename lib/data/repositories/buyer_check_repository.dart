import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';

class BuyerCheckRepository {
  final MockDb _db;

  const BuyerCheckRepository(this._db);

  BuyerCheckResult get lastResult => _db.lastBuyerCheck;
}
