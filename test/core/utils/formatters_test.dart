import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/utils/currency_formatter.dart';
import 'package:vngrocery/core/utils/weight_formatter.dart';

void main() {
  group('formatCurrencyVnd', () {
    test('formats positive, zero, and negative amounts', () {
      expect(formatCurrencyVnd(20000), '20.000 đ');
      expect(formatCurrencyVnd(0), '0 đ');
      expect(formatCurrencyVnd(-1500000), '-1.500.000 đ');
    });
  });

  group('formatWeightGrams', () {
    test('keeps grams below 1000 and converts larger values to kg', () {
      expect(formatWeightGrams(500), '500 g');
      expect(formatWeightGrams(1000), '1 kg');
      expect(formatWeightGrams(1500), '1.5 kg');
    });
  });
}
