import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/utils/format.dart';

/// Turns the server's history keys into something readable.
///
/// Actions and field names arrive as machine keys (`product.updated`, `price`)
/// because that is what the audit log records. Translating them here keeps the
/// log honest — an unknown key is shown as-is rather than hidden, since it
/// still describes a real change.
class ProductHistoryCopy {
  const ProductHistoryCopy._();

  static String action(AppLocalizations l10n, String action) {
    switch (action) {
      case 'product.created':
        return l10n.productHistoryActionCreated;
      case 'product.updated':
        return l10n.productHistoryActionUpdated;
      case 'product.deleted':
        return l10n.productHistoryActionDeleted;
      case 'product.moderated':
        return l10n.productHistoryActionModerated;
      default:
        return action;
    }
  }

  static String field(AppLocalizations l10n, String field) {
    switch (field) {
      case 'price':
        return l10n.productFieldPrice;
      case 'name':
        return l10n.productFieldName;
      case 'description':
        return l10n.productFieldDescription;
      case 'category':
        return l10n.productFieldCategory;
      case 'freshnessScore':
        return l10n.productFieldFreshnessScore;
      case 'freshnessNote':
        return l10n.productFieldFreshnessNote;
      case 'status':
        return l10n.productFieldStatus;
      case 'tags':
        return l10n.productFieldTags;
      case 'images':
        return l10n.productFieldImages;
      case 'currency':
        return l10n.productFieldCurrency;
      default:
        return field;
    }
  }

  /// Formats a value the way that field is normally read: a price as money
  /// rather than as the bare number the log stores.
  static String value(String field, String raw) {
    if (field != 'price') return raw;
    final amount = num.tryParse(raw);
    return amount == null ? raw : formatVnd(amount.round());
  }
}
