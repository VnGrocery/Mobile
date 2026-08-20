import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';

class PledgeRepository {
  final MockDb _db;
  final RemoteDataSource? _remote;
  Map<String, Object?>? latestQrPayload;

  PledgeRepository(this._db, [this._remote]);

  List<PledgeHistoryItem> ofProduct(String productId) {
    return List.unmodifiable(_db.pledgesOf(productId));
  }

  void add(String productId, PledgeHistoryItem item) {
    _db.addPledge(productId, item);
  }

  Future<List<PledgeHistoryItem>> refresh(
    String shopId,
    String productId,
  ) async {
    final remote = _remote;
    if (remote == null) return ofProduct(productId);
    final items = await remote.pledges(shopId, productId);
    _db.pledgesByProduct[productId] = items;
    return List.unmodifiable(items);
  }

  /// The server's blockchain verdict for the newest pledge on a product.
  ///
  /// Returns null when there is no backend or the product has no pledge yet, so
  /// callers can simply skip the badge.
  Future<PledgeProof?> latestProof(String shopId, String productId) async {
    final remote = _remote;
    if (remote == null) return null;
    return remote.latestProductProof(shopId, productId);
  }

  RemoteDataSource? get remote => _remote;
}
