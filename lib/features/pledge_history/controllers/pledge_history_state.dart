import 'package:vngrocery/data/models.dart';

class PledgeHistoryState {
  final List<PledgeHistoryItem> history;

  /// Needed to open the blockchain certificate, which is addressed by
  /// shop + pledge.
  final String shopId;

  const PledgeHistoryState({this.history = const [], this.shopId = ''});

  bool get isEmpty => history.isEmpty;
}
