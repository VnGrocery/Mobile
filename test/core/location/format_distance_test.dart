import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/utils/format.dart';

void main() {
  group('formatDistance', () {
    test('reads in metres under a kilometre', () {
      expect(formatDistance(0.42), '420 m');
      expect(formatDistance(0.999), '1000 m');
    });

    test('rounds to 10 m so a jittery GPS fix does not flicker the label', () {
      expect(formatDistance(0.4234), '420 m');
      expect(formatDistance(0.4236), '420 m');
    });

    test('reads in kilometres above one, to one decimal', () {
      expect(formatDistance(1), '1.0 km');
      expect(formatDistance(12.19), '12.2 km');
    });
  });
}
