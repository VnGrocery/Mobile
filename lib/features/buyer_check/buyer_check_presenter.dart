import 'package:flutter/material.dart';

import 'package:vngrocery/core/network/api_exception.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

class BuyerCheckPresenter {
  const BuyerCheckPresenter._();

  /// Turns a failed check into something a shopper can act on.
  ///
  /// The scanner used to print the error straight into the snackbar, so a
  /// Vietnamese reader holding a phone in a market was shown the server's raw
  /// English - "rate limit exceeded" - with no hint of what to do next.
  static String errorMessage(Object error, AppLocalizations l10n) {
    if (error is! ApiException) return l10n.buyerCheckErrorNetwork;
    if (error.statusCode == 429) {
      // The server sends the wait; without it the only honest thing left to
      // say is the generic line, since a made-up number would be worse.
      final minutes = error.retryAfterMinutes;
      return minutes == null
          ? l10n.buyerCheckErrorGeneric
          : l10n.buyerCheckErrorRateLimited(minutes);
    }
    return l10n.buyerCheckErrorGeneric;
  }

  static bool isNearStore(BuyerCheckResult result) {
    return result.locationStatus == 'near';
  }

  static IconData locationIcon(BuyerCheckResult result) {
    return isNearStore(result) ? Icons.gps_fixed : Icons.gps_off;
  }

  static Color locationColor(BuyerCheckResult result) {
    return isNearStore(result) ? AppColors.trustGreen : AppColors.warningOrange;
  }

  static String locationLabel(BuyerCheckResult result, AppLocalizations l10n) {
    return isNearStore(result)
        ? l10n.buyerCheckLocationNear
        : l10n.buyerCheckLocationNeedsMore;
  }

  static String locationDescription(
    BuyerCheckResult result,
    AppLocalizations l10n,
  ) {
    return isNearStore(result)
        ? l10n.buyerCheckLocationNearBody
        : l10n.buyerCheckLocationNeedsMoreBody;
  }
}
