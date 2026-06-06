import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

class BuyerCheckPresenter {
  const BuyerCheckPresenter._();

  static bool isNearStore(BuyerCheckResult result) {
    return result.locationStatus == 'near';
  }

  static IconData locationIcon(BuyerCheckResult result) {
    return isNearStore(result) ? Icons.gps_fixed : Icons.gps_off;
  }

  static Color locationColor(BuyerCheckResult result) {
    return isNearStore(result) ? AppColors.trustGreen : AppColors.warningOrange;
  }

  static String locationLabel(
    BuyerCheckResult result,
    AppLocalizations l10n,
  ) {
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
