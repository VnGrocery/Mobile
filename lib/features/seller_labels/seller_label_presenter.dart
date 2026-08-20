import 'package:vngrocery/l10n/app_localizations.dart';

/// Text the seller copies off a printed label.
///
/// There used to be two copies of this: one here that nothing called, and one
/// built inside [QrLabelCubit], both with the Vietnamese wording hardcoded so
/// an English seller copied a Vietnamese label. This is the only one now, and
/// it takes the wording from the locale.
class SellerLabelPresenter {
  const SellerLabelPresenter._();

  static String clipboardText(
    AppLocalizations l10n, {
    required String pledgeId,
    String bundleId = '',
    String bundleToken = '',
  }) {
    // Product name, not a sentence: it reads the same in every locale.
    final lines = <String>['VnGrocery Check'];

    if (pledgeId.trim().isNotEmpty) {
      lines.add(l10n.qrLabelClipboardPledge(pledgeId.trim()));
    }
    // A pledge that has not been through the QR step has no bundle yet;
    // printing "Mã lô:" with nothing after it just looks broken.
    if (bundleId.trim().isNotEmpty) {
      lines.add(l10n.qrLabelClipboardBundle(bundleId.trim()));
    }
    if (bundleToken.trim().isNotEmpty) {
      lines.add(l10n.qrLabelClipboardToken(bundleToken.trim()));
    }

    return lines.join('\n');
  }
}
