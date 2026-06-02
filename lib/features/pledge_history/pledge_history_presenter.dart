import '../../data/models.dart';
import '../../data/repositories.dart';

class PledgeHistoryPresenter {
  const PledgeHistoryPresenter._();

  static final AppRepositories _repos = AppRepositories.instance;

  static List<PledgeHistoryItem> history(String productId) {
    return _repos.pledges.ofProduct(productId);
  }
}
