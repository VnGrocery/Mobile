/// Lowercases text and strips Vietnamese diacritics.
///
/// Typing without tone marks is how Vietnamese is normally entered on a phone,
/// and a plain substring match meant "Huu Co" found nothing while "Hữu Cơ" sat
/// in the list. Both the stored text and the query go through this, so either
/// spelling finds the other.
///
/// The rules are an explicit table, matching the server's textsearch package
/// character for character. Dart has no Unicode normaliser, and a search that
/// folds differently on each side is worse than one that does not fold at all.
String foldSearchText(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return '';

  final folded = StringBuffer();
  for (final symbol in trimmed.toLowerCase().runes) {
    // Text already decomposed carries its tone as a separate combining mark;
    // the base letter is kept and the mark dropped.
    if (symbol >= 0x0300 && symbol <= 0x036F) continue;

    final plain = _vietnamese[String.fromCharCode(symbol)];
    folded.write(plain ?? String.fromCharCode(symbol));
  }
  return folded.toString();
}

/// Whether [haystack] contains [needle], both folded.
bool searchContains(String haystack, String needle) =>
    foldSearchText(haystack).contains(foldSearchText(needle));

/// Every accented lowercase letter mapped to its plain form. Uppercase is
/// handled by lowercasing first.
final Map<String, String> _vietnamese = _buildTable({
  'a': 'àáảãạăằắẳẵặâầấẩẫậ',
  'e': 'èéẻẽẹêềếểễệ',
  'i': 'ìíỉĩị',
  'o': 'òóỏõọôồốổỗộơờớởỡợ',
  'u': 'ùúủũụưừứửữự',
  'y': 'ỳýỷỹỵ',
  // d with stroke is a letter in its own right, not an accented d, so no
  // amount of decomposition would ever reduce it.
  'd': 'đ',
});

Map<String, String> _buildTable(Map<String, String> groups) {
  final table = <String, String>{};
  groups.forEach((plain, accented) {
    for (final symbol in accented.split('')) {
      table[symbol] = plain;
    }
  });
  return table;
}
