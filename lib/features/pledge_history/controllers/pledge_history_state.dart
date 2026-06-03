import 'package:vngrocery/data/models.dart';

class PledgeHistoryState {
  final List<PledgeHistoryItem> history;

  const PledgeHistoryState({this.history = const []});

  bool get isEmpty => history.isEmpty;
}
