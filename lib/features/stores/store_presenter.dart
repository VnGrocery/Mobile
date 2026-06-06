import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

class StorePresenter {
  const StorePresenter._();

  static String shareText(Shop shop, AppLocalizations l10n) {
    return '${shop.name}\n${shop.address}\n${l10n.storeShareSummary(shop.rating.toString(), shop.reviewCount)}';
  }
}
