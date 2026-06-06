import 'package:vngrocery/l10n/app_localizations.dart';

class ExplorePresenter {
  const ExplorePresenter._();

  static List<String> filters(AppLocalizations l10n) => [
    l10n.exploreFilterTopRated,
    l10n.exploreFilterRecorded,
    l10n.exploreFilterNearby,
    l10n.exploreFilterNewest,
  ];
}
