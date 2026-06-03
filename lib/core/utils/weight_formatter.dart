String formatWeightGrams(int grams) {
  if (grams.abs() < 1000) return '$grams g';
  final kg = grams / 1000;
  final text =
      kg == kg.roundToDouble() ? kg.toStringAsFixed(0) : kg.toStringAsFixed(1);
  return '$text kg';
}
