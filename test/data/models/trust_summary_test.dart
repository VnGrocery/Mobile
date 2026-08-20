import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';

/// Captured from a real `GET /v1/shops/{id}` response.
const _shopPayload = <String, Object?>{
  'shopId': 'f81e80d0-4c9a-47f5-8eee-9566c9db9bf6',
  'ownerUserId': '79341ff5-8d73-4a31-a3f1-3e70a14233f3',
  'version': 1,
  'name': 'E2E Trust Shop',
  'description': 'E2E shop',
  'address': '123 E2E St',
  'latitude': 10.76,
  'longitude': 106.66,
  'status': 'active',
  'trustSummary': <String, Object?>{
    'hasPledges': true,
    'pledgeCount': 1,
    'latestPledgeId': 'a273aaf8-801c-4df1-a04a-b20f38936cb6',
    'latestScore': 8.6,
    'score': 81.4,
    'grade': 'good',
    'formulaVersion': 'trust_score_v2',
    'pledgeScore': 87.8,
    'reviewScore': 50,
    'buyerCheckScore': 50,
    'consistencyScore': 70,
    'recencyScore': 100,
    'coverageScore': 40,
    'buyerCheckCount': 0,
    'trustedCheckCount': 0,
    'highRiskCheckCount': 0,
    'reasons': <Object?>['partial_trust_data', 'no_customer_reviews'],
  },
  'ratingSummary': <String, Object?>{'ratingCount': 0, 'averageRating': 0},
};

void main() {
  group('TrustSummary', () {
    test('parses the summary attached to a shop response', () {
      final shop = Shop.fromJson(_shopPayload);
      final trust = shop.trustSummary;

      expect(trust, isNotNull);
      expect(trust!.score, 81.4);
      expect(trust.grade, TrustGrade.good);
      expect(trust.pledgeCount, 1);
      expect(trust.reasons, contains('no_customer_reviews'));
      expect(trust.hasData, isTrue);
    });

    test('exposes the six components in a fixed order', () {
      final trust = Shop.fromJson(_shopPayload).trustSummary!;

      expect(trust.components.map((c) => c.key), [
        'pledge',
        'review',
        'buyerCheck',
        'consistency',
        'recency',
        'coverage',
      ]);
      expect(trust.components.first.score, 87.8);
    });

    test('maps every grade the server can send', () {
      TrustGrade grade(String value) =>
          TrustSummary.fromJson({'grade': value}).grade;

      expect(grade('excellent'), TrustGrade.excellent);
      expect(grade('good'), TrustGrade.good);
      expect(grade('watch'), TrustGrade.watch);
      expect(grade('risk'), TrustGrade.risk);
      // Anything unexpected is treated as the most cautious band.
      expect(grade('brand_new_grade'), TrustGrade.risk);
    });

    test('a shop with no signal reports hasData false', () {
      final trust = TrustSummary.fromJson({
        'hasPledges': false,
        'pledgeCount': 0,
        'buyerCheckCount': 0,
        'score': 0,
        'grade': 'risk',
      });

      // Score 0 here means "nothing to judge yet", not "untrustworthy".
      expect(trust.hasData, isFalse);
    });

    test('shop without trustSummary stays null rather than defaulting', () {
      final shop = Shop.fromJson({
        'shopId': 's1',
        'name': 'n',
        'address': 'a',
        'description': 'd',
      });

      expect(shop.trustSummary, isNull);
    });

    test('round-trips through the shop toJson', () {
      final shop = Shop.fromJson(_shopPayload);
      final again = Shop.fromJson(shop.toJson());

      expect(again.trustSummary?.score, 81.4);
      expect(again.trustSummary?.grade, TrustGrade.good);
      expect(again.trustSummary?.reasons.length, 2);
    });
  });
}
