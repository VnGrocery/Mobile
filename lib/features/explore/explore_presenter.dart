import 'package:vngrocery/l10n/app_localizations.dart';

/// Stable identifiers for the store filters. The chips display a translated
/// label, so the selection has to be tracked by key or the highlight breaks as
/// soon as the language changes.
class ExploreFilters {
  const ExploreFilters._();

  static const topRated = 'top_rated';
  static const recorded = 'recorded';
  static const newest = 'newest';

  /// "Nearby" is deliberately absent: the app has no location permission or
  /// geolocation package, so it could only ever be a chip that does nothing.
  static const keys = <String>[topRated, recorded, newest];
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
      case ExploreFilters.topRated:
      default:
        return l10n.exploreFilterTopRated;
    }
  }
}
