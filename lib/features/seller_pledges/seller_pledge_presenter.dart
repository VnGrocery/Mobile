import 'package:vngrocery/features/home/category_presenter.dart';
import 'package:vngrocery/features/seller_pledges/controllers/seller_pledge_state.dart';
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

  /// The score exactly as the seller typed it, trimmed.
  ///
  /// An empty field used to become '8.5' - a quality claim nobody made, signed
  /// into the product's history and anchored on chain. Nothing is invented
  /// here now; [isValidScore] decides whether there is anything to record.
  /// A Vietnamese keyboard produces a decimal comma; the server wants a dot.
  static String normalizedScore(String raw) =>
      raw.trim().replaceAll(',', '.');

  /// A score is a number from 0 to 10. Anything else cannot be recorded.
  static bool isValidScore(String raw) {
    final score = double.tryParse(normalizedScore(raw));
    return score != null && score >= 0 && score <= 10;
  }

  static String? captureFailureMessage(
    SellerPledgeCaptureFailure failure,
    AppLocalizations l10n,
  ) {
    return switch (failure) {
      SellerPledgeCaptureFailure.none => null,
      SellerPledgeCaptureFailure.invalidImage =>
        l10n.sellerPledgeCaptureInvalidImage,
      SellerPledgeCaptureFailure.unavailable =>
        l10n.sellerPledgeCaptureUnavailable,
      SellerPledgeCaptureFailure.failed => l10n.sellerPledgeCaptureFailed,
    };
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
