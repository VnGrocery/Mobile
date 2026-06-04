import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/data_hooks.dart';

class PledgeHistoryPresenter {
  const PledgeHistoryPresenter._();

  static final AppDataHooks _data = AppDataHooks.instance;

  static List<PledgeHistoryItem> history(String productId) {
    return _data.getPledges(productId);
  }
}
