import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

String passwordStrengthLabel(BuildContext context, int strength) {
  final l10n = AppLocalizations.of(context);
  return switch (strength) {
    0 || 1 => l10n.authPasswordStrengthWeakHint,
    2 || 3 => l10n.authPasswordStrengthMediumHint,
    _ => l10n.authPasswordStrengthStrongHint,
  };
}

Color passwordStrengthColor(int strength) {
  return switch (strength) {
    0 || 1 => AppColors.priceRed,
    2 || 3 => AppColors.warningOrange,
    _ => AppColors.primaryGreen,
  };
}
