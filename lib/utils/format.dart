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

/// Distance from the reader, in the unit that reads naturally at that range.
///
/// Under a kilometre people think in metres ("cách 400 m"), above it in
/// kilometres with one decimal. Rounded to the nearest 10 m so a GPS fix
/// jittering by a few metres does not make the label flicker.
String formatDistance(double km) {
  if (km < 1) {
    final metres = (km * 1000 / 10).round() * 10;
    return '$metres m';
  }
  return '${km.toStringAsFixed(1)} km';
}

/// Date and time, for a record that needs to be pinned to a moment rather than
/// just a day — when a price changed, when a listing went up.
String formatDateTime(DateTime value) {
  final local = value.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year} '
      '${two(local.hour)}:${two(local.minute)}';
}
