import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerProductPresenter {
  const SellerProductPresenter._();

  static const allState = 'all';
  // The server's own values, lower case. They used to be written here as
  // 'Draft' and 'Published', so every filter but "all" matched nothing: no
  // product ever carries a capitalised status.
  static const draftState = 'draft';
  static const publishedState = 'published';
  static const archivedState = 'archived';

  static const states = [allState, publishedState, draftState, archivedState];

  /// Categories and their labels live in [CategoryPresenter], which is what
  /// the buyer screens and the server agree on. The list that used to sit here
  /// - beef, pork, chicken, poultry, other - matched neither.

  static String stateLabel(String status, AppLocalizations l10n) {
    return switch (status.toLowerCase()) {
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
    return switch (status.toLowerCase()) {
      publishedState || 'active' => palette.positiveBg,
      draftState => palette.mutedSurface,
      _ => palette.warningBg,
    };
  }

  static Color statusForeground(String status) {
    return switch (status.toLowerCase()) {
      publishedState || 'active' => AppColors.trustGreen,
      draftState => Colors.grey,
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
