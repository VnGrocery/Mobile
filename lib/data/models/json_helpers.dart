List<String> stringList(Object? value) {
  if (value is! List) return const [];
  return value.whereType<String>().toList();
}

DateTime dateTime(Object? value) {
  if (value is DateTime) return value;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}

/// Like [dateTime] but keeps null for absent values, so "never anchored" stays
/// distinguishable from "anchored at epoch 0".
DateTime? optionalDateTime(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) {
    if (value.trim().isEmpty) return null;
    return DateTime.tryParse(value);
  }
  return null;
}
