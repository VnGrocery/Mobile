import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/utils/text_search.dart';

/// Every accented Vietnamese letter. Kept identical to the server's list, so a
/// letter added on one side and missed on the other shows up here.
const _everyAccented =
    'àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩị'
    'òóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ';

void main() {
  group('foldSearchText', () {
    test('strips tone marks', () {
      expect(foldSearchText('Hữu Cơ'), 'huu co');
    });

    test('maps d with stroke, which never decomposes', () {
      expect(foldSearchText('Đà Lạt'), 'da lat');
      expect(foldSearchText('đậu'), 'dau');
    });

    test('folds a full shop name', () {
      expect(foldSearchText('Rau Sạch Cô Ba'), 'rau sach co ba');
    });

    test('leaves plain text, digits and other scripts alone', () {
      expect(foldSearchText('rau sach'), 'rau sach');
      expect(foldSearchText('VietGAP 2024'), 'vietgap 2024');
    });

    test('trims and handles empty input', () {
      expect(foldSearchText('  Cần Giờ  '), 'can gio');
      expect(foldSearchText('   '), '');
    });

    test('covers every Vietnamese letter, with no silent holes', () {
      // A missed letter is a word that simply stops being findable.
      for (final symbol in _everyAccented.split('')) {
        final folded = foldSearchText(symbol);
        expect(folded, isNotEmpty, reason: '$symbol folded away entirely');
        expect(
          folded.codeUnitAt(0) < 128,
          isTrue,
          reason: '$symbol folded to $folded, which is still accented',
        );
      }
    });

    test('decomposed input folds like precomposed', () {
      // Text can arrive with the tone as a separate combining mark.
      const decomposed = 'Hụ̄u';
      expect(foldSearchText(decomposed), 'huu');
    });
  });

  group('searchContains', () {
    const shop = 'Rau Hữu Cơ Quận 3';

    test('finds a name typed without tone marks', () {
      // The bug: this is how the name gets typed on a phone, and it found
      // nothing.
      expect(searchContains(shop, 'huu co'), isTrue);
    });

    test('finds it typed with tone marks too', () {
      expect(searchContains(shop, 'Hữu Cơ'), isTrue);
    });

    test('is case insensitive and matches partial words', () {
      expect(searchContains(shop, 'QUAN 3'), isTrue);
    });

    test('a genuine miss is still a miss', () {
      expect(searchContains(shop, 'hai san'), isFalse);
    });

    test('an empty query does not exclude anything', () {
      expect(searchContains(shop, '  '), isTrue);
    });
  });
}
