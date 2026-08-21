import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/category_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

/// Wording for a suggestion and the reasons behind it.
class RecommendationCopy {
  const RecommendationCopy._();

  /// The section heading.
  ///
  /// Two different claims, and the difference matters: "for you" says the app
  /// learned something about this reader. When it has not, saying so anyway
  /// would be a claim the data does not support.
  static String title(AppLocalizations l10n, Recommendations recommendations) =>
      recommendations.personalised
      ? l10n.homeForYouTitle
      : l10n.homePopularTitle;

  /// The line under the heading, saying what the list rests on.
  static String basis(AppLocalizations l10n, Recommendations recommendations) =>
      recommendations.personalised
      ? l10n.homeForYouBasis(recommendations.signalCount)
      : l10n.homePopularBasis;

  /// Translates one reason. Unknown codes are dropped rather than shown raw:
  /// a reason the reader cannot read is worse than one fewer reason.
  static String? reason(
    AppLocalizations l10n,
    String code, {
    required String category,
  }) {
    switch (code) {
      case RecommendationReasons.categoryYouEngagedWith:
        return l10n.recommendReasonCategory(
          CategoryPresenter.label(l10n, category).toLowerCase(),
        );
      case RecommendationReasons.shopYouRated:
        return l10n.recommendReasonShopRated;
      case RecommendationReasons.nearYou:
        return l10n.recommendReasonNear;
      case RecommendationReasons.highTrust:
        return l10n.recommendReasonTrust;
      case RecommendationReasons.wellRated:
        return l10n.recommendReasonRated;
      default:
        return null;
    }
  }

  /// The single most useful reason to show on a card, which has room for one.
  ///
  /// Ordered by how much it tells the reader: something about them beats
  /// something about the shop, which beats a generic quality signal.
  static String? headline(
    AppLocalizations l10n,
    List<String> reasons, {
    required String category,
  }) {
    const byUsefulness = [
      RecommendationReasons.categoryYouEngagedWith,
      RecommendationReasons.shopYouRated,
      RecommendationReasons.nearYou,
      RecommendationReasons.highTrust,
      RecommendationReasons.wellRated,
    ];

    for (final code in byUsefulness) {
      if (reasons.contains(code)) {
        return reason(l10n, code, category: category);
      }
    }
    return null;
  }
}
