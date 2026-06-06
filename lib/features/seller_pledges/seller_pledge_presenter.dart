import 'package:vngrocery/data/data_hooks.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

class SellerPledgePresenter {
  const SellerPledgePresenter._();

  static final AppDataHooks _data = AppDataHooks.instance;

  static const beefCategory = 'beef';
  static const porkCategory = 'pork';
  static const chickenCategory = 'chicken';
  static const seafoodCategory = 'seafood';
  static const otherCategory = 'other';

  static const categories = [
    beefCategory,
    porkCategory,
    chickenCategory,
    seafoodCategory,
    otherCategory,
  ];

  static String categoryLabel(String category, AppLocalizations l10n) {
    return switch (category) {
      beefCategory => l10n.sellerPledgeCategoryBeef,
      porkCategory => l10n.sellerPledgeCategoryPork,
      chickenCategory => l10n.sellerPledgeCategoryChicken,
      seafoodCategory => l10n.sellerPledgeCategorySeafood,
      otherCategory => l10n.sellerPledgeCategoryOther,
      _ => category,
    };
  }

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
    return l10n.sellerPledgeRecordDescription(score, categoryLabel(category, l10n));
  }

  static void addPledge({
    required String productId,
    required String score,
    required String category,
    required AppLocalizations l10n,
  }) {
    _data.addPledge(
      productId,
      PledgeHistoryItem(
        time: l10n.sellerPledgeRecordTimeJustNow,
        title: l10n.sellerPledgeRecordTitle,
        description: recordDescription(
          score: score,
          category: category,
          l10n: l10n,
        ),
        isVerified: true,
        hasProof: true,
        proofId: _data.nextId(),
      ),
    );
  }
}
