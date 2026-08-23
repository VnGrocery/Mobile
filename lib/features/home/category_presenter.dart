import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';

/// Turns a raw product category into something showable.
///
/// Categories come from the data, not from a fixed list, so the values are
/// whatever sellers and the server use: snake_case keys like `fresh_produce`
/// alongside free text like `Thịt bò`. Known keys get a translation; anything
/// else is tidied up rather than hidden, because it is real data.
class CategoryPresenter {
  const CategoryPresenter._();

  /// Categories a seller can pick from.
  ///
  /// The seller screens used to offer their own list - beef, pork, chicken,
  /// poultry, other - which the server has never stored and no buyer filter
  /// has ever matched. A product created through that picker was effectively
  /// filed under nothing.
  static const selectable = [
    'fresh_produce',
    'vegetables',
    'fruit',
    'meat',
    'seafood',
    'poultry',
  ];

  static String label(AppLocalizations l10n, String category) {
    switch (category.toLowerCase()) {
      case 'fresh_produce':
        return l10n.homeCategoryFreshProduce;
      case 'meat':
        return l10n.homeCategoryMeat;
      case 'seafood':
        return l10n.homeCategorySeafood;
      case 'poultry':
        return l10n.homeCategoryPoultry;
      case 'vegetables':
        return l10n.homeCategoryVegetables;
      case 'fruit':
        return l10n.homeCategoryFruit;
      default:
        return _prettify(category);
    }
  }

  static IconData icon(String category) {
    switch (category.toLowerCase()) {
      case 'fresh_produce':
      case 'vegetables':
        return Icons.eco;
      case 'fruit':
        return Icons.apple;
      case 'seafood':
        return Icons.set_meal;
      case 'poultry':
        return Icons.egg_alt;
      case 'meat':
        return Icons.kebab_dining;
      default:
        return Icons.category_outlined;
    }
  }

  /// `fresh_produce` -> `Fresh produce`; free text is left as written.
  static String _prettify(String value) {
    if (!value.contains('_')) return value;
    final spaced = value.replaceAll('_', ' ');
    return spaced[0].toUpperCase() + spaced.substring(1);
  }
}
