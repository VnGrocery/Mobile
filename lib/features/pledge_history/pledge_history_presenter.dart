import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/category_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

/// Wording for a timeline entry.
///
/// [PledgeHistoryItem.fromJson] used to build these sentences itself, in
/// Vietnamese, with the raw category key pasted in — so an English reader got a
/// Vietnamese line and everyone read "fresh_produce". The model now keeps the
/// score and category raw and the wording happens here, where the locale is
/// known.
class PledgeHistoryPresenter {
  const PledgeHistoryPresenter._();

  static String title(AppLocalizations l10n, PledgeHistoryItem item) {
    final title = item.title.trim();
    return title.isEmpty ? l10n.pledgeHistoryDefaultTitle : title;
  }

  static String description(AppLocalizations l10n, PledgeHistoryItem item) {
    final description = item.description.trim();
    if (description.isNotEmpty) return description;

    final score = item.score;
    if (score == null) return '';

    final category = item.category?.trim() ?? '';
    if (category.isEmpty) return l10n.pledgeHistoryScoreOnly(_score(score));

    return l10n.pledgeHistoryScoreLine(
      _score(score),
      CategoryPresenter.label(l10n, category),
    );
  }

  static String _score(double score) => score.toStringAsFixed(1);
}
