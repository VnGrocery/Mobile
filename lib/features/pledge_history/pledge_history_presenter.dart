import '../../data/data_hooks.dart';
import '../../data/models.dart';

class PledgeHistoryPresenter {
  const PledgeHistoryPresenter._();

  static List<PledgeHistoryItem> history(String productId) {
    return AppDataHooks.instance.getPledges(productId);
  }
}
