import 'package:vngrocery/features/home/category_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

class SellerPledgePresenter {
  const SellerPledgePresenter._();

  /// Categories and their labels come from [CategoryPresenter].
  ///
  /// This file used to carry a third copy of that list - beef, pork, chicken,
  /// seafood, other - which neither the server nor the buyer screens have ever
  /// used. Recording a pledge therefore filed it under a category nothing else
  /// could match, and any real category printed as its raw key.

  static String titleForStep(int step, AppLocalizations l10n) {
    return switch (step) {
      1 => l10n.sellerPledgeStepCapture,
      2 => l10n.sellerPledgeStepEvaluate,
      _ => l10n.sellerPledgeStepConfirm,
    };
  }

  static String normalizedScore(String raw) {
    return raw.trim().isEmpty ? '8.5' : raw.trim();
  }

  static String recordDescription({
    required String score,
    required String category,
    required AppLocalizations l10n,
  }) {
    return l10n.sellerPledgeRecordDescription(
      score,
      CategoryPresenter.label(l10n, category),
    );
  }
}
