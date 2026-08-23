import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerProductPresenter {
  const SellerProductPresenter._();

  static const allState = 'all';
  static const draftState = 'Draft';
  static const publishedState = 'Published';
  static const archivedState = 'Archived';

  static const states = [allState, publishedState, draftState, archivedState];

  /// Categories and their labels live in [CategoryPresenter], which is what
  /// the buyer screens and the server agree on. The list that used to sit here
  /// - beef, pork, chicken, poultry, other - matched neither.

  static String stateLabel(String status, AppLocalizations l10n) {
    return switch (status) {
      allState => l10n.sellerProductStateAll,
      publishedState => l10n.sellerProductStatePublished,
      draftState => l10n.sellerProductStateDraft,
      archivedState => l10n.sellerProductStateArchived,
      _ => status,
    };
  }

  static String freshnessNote(bool hasImage, AppLocalizations l10n) {
    return hasImage
        ? l10n.sellerProductFreshnessWithImage
        : l10n.sellerProductFreshnessWithoutImage;
  }

  static Color statusBackground(BuildContext context, String status) {
    final palette = context.palette;
    return switch (status) {
      'Published' => palette.positiveBg,
      'Draft' => palette.mutedSurface,
      _ => palette.warningBg,
    };
  }

  static Color statusForeground(String status) {
    return switch (status) {
      'Published' => AppColors.trustGreen,
      'Draft' => Colors.grey,
      _ => AppColors.warningOrange,
    };
  }

  static int parsePrice(String value) {
    return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  static List<String> parseTags(String value) {
    return value
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }
}
