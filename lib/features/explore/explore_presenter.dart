import 'package:vngrocery/l10n/app_localizations.dart';

/// Stable identifiers for the store filters. The chips display a translated
/// label, so the selection has to be tracked by key or the highlight breaks as
/// soon as the language changes.
class ExploreFilters {
  const ExploreFilters._();

  static const nearby = 'nearby';
  static const topRated = 'top_rated';
  static const recorded = 'recorded';
  static const newest = 'newest';

  /// Nearest first, because that is what decides where someone actually buys
  /// fresh produce. It leads the row and is selected as soon as the app knows
  /// where the reader is.
  static const keys = <String>[nearby, topRated, recorded, newest];
}

class ExplorePresenter {
  const ExplorePresenter._();

  static List<String> filters(AppLocalizations l10n) => ExploreFilters.keys;

  static String filterLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case ExploreFilters.recorded:
        return l10n.exploreFilterRecorded;
      case ExploreFilters.newest:
        return l10n.exploreFilterNewest;
      case ExploreFilters.nearby:
        return l10n.exploreFilterNearby;
      case ExploreFilters.topRated:
      default:
        return l10n.exploreFilterTopRated;
    }
  }
}
