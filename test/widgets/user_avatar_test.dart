import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/widgets/user_avatar.dart';

void main() {
  group('UserAvatar.initialsOf', () {
    test('takes the first and last word', () {
      expect(UserAvatar.initialsOf('Trần Minh Anh'), 'TA');
    });

    test('keeps Vietnamese diacritics on the letter', () {
      expect(UserAvatar.initialsOf('Đặng Phương'), 'ĐP');
    });

    test('a single word gives one letter', () {
      expect(UserAvatar.initialsOf('Ba'), 'B');
    });

    test('collapses extra whitespace', () {
      expect(UserAvatar.initialsOf('  Khách   Demo  '), 'KD');
    });

    test('no name falls back to the glyph', () {
      expect(UserAvatar.initialsOf(''), isNull);
      expect(UserAvatar.initialsOf('   '), isNull);
    });
  });
}
