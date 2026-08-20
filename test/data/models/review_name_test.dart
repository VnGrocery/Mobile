import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';

Review _parse(Map<String, Object?> json) => Review.fromJson({
  'reviewId': 'r1',
  'rating': 5,
  'comment': 'Rau tươi',
  ...json,
});

void main() {
  group('Review author name', () {
    test('comes from the server field', () {
      expect(_parse({'reviewerName': 'Trần Minh Anh'}).userName, 'Trần Minh Anh');
    });

    test('is empty when the account has no display name', () {
      // The UI turns this into a localized generic label; the data layer must
      // not invent a name of its own.
      expect(_parse({'reviewerName': ''}).userName, '');
      expect(_parse({}).userName, '');
    });

    test('never falls back to the raw reviewer id', () {
      expect(_parse({'reviewerUserId': 'e3b0c442-98fc-1c14'}).userName, '');
    });
  });
}
