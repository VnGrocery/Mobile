import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';

class PledgeHistoryPresenter {
  const PledgeHistoryPresenter._();

  static final AppRepositories _repos = AppRepositories.instance;

  static List<PledgeHistoryItem> history(String productId) {
    return _repos.pledges.ofProduct(productId);
  }
}
