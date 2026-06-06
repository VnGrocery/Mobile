import 'package:flutter/material.dart';

import 'package:vngrocery/data/data_hooks.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerProductPresenter {
  const SellerProductPresenter._();

  static final AppDataHooks _data = AppDataHooks.instance;

  static const allState = 'all';
  static const draftState = 'Draft';
  static const publishedState = 'Published';
  static const archivedState = 'Archived';

  static const states = [
    allState,
    publishedState,
    draftState,
    archivedState,
  ];

  static const beefCategory = 'beef';
  static const porkCategory = 'pork';
  static const chickenCategory = 'chicken';
  static const seafoodCategory = 'seafood';
  static const poultryCategory = 'poultry';
  static const otherCategory = 'other';

  static const categories = [
    beefCategory,
    porkCategory,
    chickenCategory,
    seafoodCategory,
    poultryCategory,
    otherCategory,
  ];

  static String stateLabel(String status, AppLocalizations l10n) {
    return switch (status) {
      allState => l10n.sellerProductStateAll,
      publishedState => l10n.sellerProductStatePublished,
      draftState => l10n.sellerProductStateDraft,
      archivedState => l10n.sellerProductStateArchived,
      _ => status,
    };
  }

  static String categoryLabel(String category, AppLocalizations l10n) {
    return switch (category) {
      beefCategory => l10n.sellerCategoryBeef,
      porkCategory => l10n.sellerCategoryPork,
      chickenCategory => l10n.sellerCategoryChicken,
      seafoodCategory => l10n.sellerCategorySeafood,
      poultryCategory => l10n.sellerCategoryPoultry,
      otherCategory => l10n.sellerCategoryOther,
      _ => category,
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

  static List<Product> filteredProducts({
    required String shopId,
    required String state,
  }) {
    final all = _data.getProducts(shopId: shopId);
    if (state == allState) return all;
    return all.where((product) => product.status == state).toList();
  }

  static Product addProduct({
    required String shopId,
    required String name,
    required String description,
    required String category,
    required bool hasImage,
    required String price,
    required String tags,
    required AppLocalizations l10n,
  }) {
    final product = Product(
      id: _data.nextId(),
      shopId: shopId,
      name: name.trim(),
      description: description.trim(),
      category: category,
      freshnessScore: 80,
      freshnessNote: freshnessNote(hasImage, l10n),
      price: parsePrice(price),
      tags: parseTags(tags),
      status: 'Draft',
    );
    _data.addProduct(product);
    return product;
  }
}
