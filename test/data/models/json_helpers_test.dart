import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models/json_helpers.dart';

void main() {
  group('json_helpers', () {
    test('stringList keeps only string values', () {
      expect(stringList(['fresh', 1, null, 'local']), ['fresh', 'local']);
      expect(stringList(null), isEmpty);
    });

    test('dateTime parses supported values and fails closed', () {
      final date = DateTime(2026, 6, 3);

      expect(dateTime(date), date);
      expect(dateTime(date.millisecondsSinceEpoch), date);
      expect(dateTime(date.toIso8601String()), date);
      expect(dateTime('bad'), DateTime.fromMillisecondsSinceEpoch(0));
      expect(dateTime(null), DateTime.fromMillisecondsSinceEpoch(0));
    });
  });
}
