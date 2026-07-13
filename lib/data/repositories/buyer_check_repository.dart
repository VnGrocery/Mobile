import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';

class BuyerCheckRepository {
  final MockDb _db;

  BuyerCheckRepository(this._db);

  BuyerCheckResult get lastResult => _db.lastBuyerCheck;
  String? lastProductId;

  void setResult(BuyerCheckResult result, {String? productId}) {
    _db.lastBuyerCheck = result;
    lastProductId = productId;
  }
}
