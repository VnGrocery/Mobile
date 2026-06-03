String formatCurrencyVnd(int amount) {
  final raw = amount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write('.');
    buffer.write(raw[i]);
  }
  final sign = amount < 0 ? '-' : '';
  return '$sign${buffer} đ';
}
