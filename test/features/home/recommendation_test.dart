import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/recommendation_copy.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/l10n/app_localizations_en.dart';
import 'package:vngrocery/l10n/app_localizations_vi.dart';

Recommendations _parse(Map<String, Object?> json) =>
    Recommendations.fromJson(json);

void main() {
  final AppLocalizations vi = AppLocalizationsVi();
  final AppLocalizations en = AppLocalizationsEn();

  group('Recommendations.fromJson', () {
    test('reads the suggestions and what they rest on', () {
      final recommendations = _parse({
        'personalised': true,
        'signalCount': 3,
        'categories': ['fruit', 'vegetables'],
        'products': [
          {
            'productId': 'p1',
            'shopId': 's1',
            'shopName': 'Rau Hữu Cơ Quận 3',
            'name': 'Cải kale xoăn',
            'category': 'vegetables',
            'price': 72000,
            'score': 0.44,
            'reasons': ['category_you_engaged_with', 'high_trust'],
            'distanceKm': 1.2,
          },
        ],
      });

      expect(recommendations.personalised, isTrue);
      expect(recommendations.signalCount, 3);
      expect(recommendations.products.single.reasons, hasLength(2));
      expect(recommendations.products.single.distanceKm, 1.2);
    });

    test('a reader with no history is not marked personalised', () {
      final recommendations = _parse({'personalised': false, 'signalCount': 0});

      expect(recommendations.personalised, isFalse);
      expect(recommendations.isEmpty, isTrue);
    });

    test('an unmeasured distance stays null rather than becoming zero', () {
      // Zero would read as "you are standing at the shop".
      final recommendations = _parse({
        'products': [
          {'productId': 'p1', 'shopId': 's1', 'name': 'x', 'price': 1000},
        ],
      });

      expect(recommendations.products.single.distanceKm, isNull);
    });
  });

  group('RecommendationCopy.title', () {
    test('claims personalisation only when the data supports it', () {
      const personal = Recommendations(personalised: true, signalCount: 3);
      const popular = Recommendations(personalised: false);

      expect(RecommendationCopy.title(vi, personal), 'Gợi ý cho bạn');
      expect(RecommendationCopy.title(vi, popular), isNot('Gợi ý cho bạn'));
      expect(RecommendationCopy.title(en, popular), 'Widely trusted');
    });

    test('says what the list rests on, either way', () {
      const personal = Recommendations(personalised: true, signalCount: 3);

      expect(RecommendationCopy.basis(vi, personal), contains('3'));
      expect(
        RecommendationCopy.basis(vi, const Recommendations()),
        isNot(contains('3')),
      );
    });
  });

  group('RecommendationCopy.reason', () {
    test('translates the category reason with a readable category name', () {
      final text = RecommendationCopy.reason(
        vi,
        RecommendationReasons.categoryYouEngagedWith,
        category: 'fresh_produce',
      );

      // Not the raw key.
      expect(text, isNot(contains('fresh_produce')));
      expect(text, contains('nông sản tươi'));
    });

    test('drops a reason it cannot translate', () {
      // Showing a raw server key would be worse than one fewer reason.
      expect(
        RecommendationCopy.reason(vi, 'something_new', category: 'fruit'),
        isNull,
      );
    });
  });

  group('RecommendationCopy.headline', () {
    test('prefers what it knows about the reader over generic quality', () {
      final text = RecommendationCopy.headline(en, const [
        RecommendationReasons.wellRated,
        RecommendationReasons.highTrust,
        RecommendationReasons.categoryYouEngagedWith,
      ], category: 'fruit');

      expect(text, contains('fruit'));
    });

    test('falls through to the next most useful reason', () {
      final text = RecommendationCopy.headline(en, const [
        RecommendationReasons.wellRated,
        RecommendationReasons.nearYou,
      ], category: 'fruit');

      expect(text, 'Near you');
    });

    test('says nothing when there is nothing to say', () {
      expect(
        RecommendationCopy.headline(en, const [], category: 'fruit'),
        isNull,
      );
      expect(
        RecommendationCopy.headline(en, const ['unknown'], category: 'fruit'),
        isNull,
      );
    });
  });
}
