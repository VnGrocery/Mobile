import 'package:vngrocery/core/utils/currency_formatter.dart';

String formatVnd(int amount) {
  return formatCurrencyVnd(amount);
}

/// One decimal place for a star rating.
///
/// The server returns an average, so three 5/4/5 reviews arrive as
/// 4.666666666666667 and printing it raw filled the badge with digits.
String formatRating(double rating) => rating.toStringAsFixed(1);

/// Short local date for timestamps that arrive as ISO strings.
///
/// Falls back to the original text when it cannot be parsed, so an unexpected
/// format degrades to something readable instead of disappearing.
String formatShortDate(String isoOrText) {
  final parsed = DateTime.tryParse(isoOrText);
  if (parsed == null) return isoOrText;
  final local = parsed.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day/$month/${local.year}';
}
