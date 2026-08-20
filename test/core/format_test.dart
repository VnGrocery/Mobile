import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/utils/format.dart';

void main() {
  group('formatRating', () {
    test('keeps one decimal for a computed average', () {
      // Three reviews of 5, 4 and 5 come back from the server like this.
      expect(formatRating(4.666666666666667), '4.7');
    });

    test('shows a trailing zero so the width stays stable', () {
      expect(formatRating(5), '5.0');
      expect(formatRating(0), '0.0');
    });

    test('rounds rather than truncates', () {
      expect(formatRating(3.44), '3.4');
      expect(formatRating(3.45), '3.5');
    });
  });

  group('formatShortDate', () {
    test('turns a server timestamp into a short local date', () {
      expect(
        formatShortDate('2026-08-20T15:53:09.209Z'),
        matches(r'^\d{2}/\d{2}/2026$'),
      );
    });

    test('pads day and month', () {
      expect(
        formatShortDate('2026-01-05T00:00:00Z'),
        matches(r'^\d{2}/\d{2}/2026$'),
      );
    });

    test('leaves unparseable text alone instead of blanking it', () {
      expect(formatShortDate('hôm qua'), 'hôm qua');
      expect(formatShortDate(''), '');
    });
  });
}
