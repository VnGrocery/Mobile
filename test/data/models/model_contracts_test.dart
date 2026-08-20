import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/mock_json_data.dart';
import 'package:vngrocery/data/models/buyer_check_result.dart';
import 'package:vngrocery/data/models/pledge_history_item.dart';
import 'package:vngrocery/data/models/product.dart';
import 'package:vngrocery/data/models/review.dart';
import 'package:vngrocery/data/models/shop.dart';
import 'package:vngrocery/data/models/user_voucher.dart';
import 'package:vngrocery/data/models/voucher.dart';

void main() {
  group('mock backend JSON contract', () {
    test('parses shops with stable keys', () {
      final shops = appMockJson['shops'] as List<Object?>;

      for (final item in shops.cast<Map<String, Object?>>()) {
        final json = Shop.fromJson(item).toJson();
        expect(
          json.keys,
          containsAll(<String>[
            'id',
            'name',
            'address',
            'rating',
            'reviewCount',
            'description',
            'logoUrl',
          ]),
        );
      }
    });

    test('parses products with stable keys and string tags', () {
      final products = appMockJson['products'] as List<Object?>;

      for (final item in products.cast<Map<String, Object?>>()) {
        final json = Product.fromJson(item).toJson();
        expect(
          json.keys,
          containsAll(<String>[
            'id',
            'shopId',
            'name',
            'description',
            'category',
            'freshnessScore',
            'freshnessNote',
            'price',
            'tags',
            'status',
          ]),
        );
        expect(json['tags'], isA<List<String>>());
      }

      final coercedTags = Product.fromJson({
        'id': 'p-test',
        'shopId': 's-test',
        'name': 'N',
        'description': 'D',
        'category': 'C',
        'freshnessScore': 90,
        'freshnessNote': 'F',
        'price': 1,
        'tags': ['fresh', 1, null, 'clean'],
        'status': 'Published',
      });
      expect(coercedTags.tags, ['fresh', 'clean']);

      final nonListTags = Product.fromJson({
        'id': 'p-test-2',
        'shopId': 's-test',
        'name': 'N',
        'description': 'D',
        'category': 'C',
        'freshnessScore': 90,
        'freshnessNote': 'F',
        'price': 1,
        'tags': 'fresh,clean',
        'status': 'Published',
      });
      expect(nonListTags.tags, isEmpty);
    });

    test('parses grouped reviews with stable keys', () {
      final groups = appMockJson['reviewsByShop'] as Map<String, Object?>;

      for (final group in groups.values.cast<List<Object?>>()) {
        for (final item in group.cast<Map<String, Object?>>()) {
          final json = Review.fromJson(item).toJson();
          expect(
            json.keys,
            containsAll(<String>[
              'id',
              'userName',
              'rating',
              'comment',
              'date',
            ]),
          );
        }
      }
    });

    test('parses grouped pledges and defaults proof fields', () {
      final groups = appMockJson['pledgesByProduct'] as Map<String, Object?>;

      for (final group in groups.values.cast<List<Object?>>()) {
        for (final item in group.cast<Map<String, Object?>>()) {
          final json = PledgeHistoryItem.fromJson(item).toJson();
          expect(
            json.keys,
            containsAll(<String>[
              'time',
              'title',
              'description',
              'isVerified',
              'hasProof',
              'proofId',
            ]),
          );
        }
      }

      final minimal = PledgeHistoryItem.fromJson({
        'time': '2026-06-01T00:00:00',
        'title': 'T',
        'description': 'D',
        'isVerified': true,
      });
      expect(minimal.hasProof, isFalse);
      expect(minimal.proofId, isEmpty);
    });

    test('maps server integrityStatus values onto isVerified', () {
      PledgeHistoryItem parse(String? status) => PledgeHistoryItem.fromJson({
        'pledgeId': 'pledge-1',
        'committedAt': '2026-06-01T00:00:00',
        if (status != null) 'integrityStatus': status,
      });

      // The server only ever emits these five values.
      expect(parse('anchored').isVerified, isTrue);
      expect(parse('reanchored').isVerified, isTrue);
      expect(parse('pending_anchor').isVerified, isFalse);
      expect(parse('mismatch_detected').isVerified, isFalse);
      expect(parse('revoked').isVerified, isFalse);
      expect(parse(null).isVerified, isFalse);

      // The raw status is kept so the timeline can name which state it is in.
      expect(parse('pending_anchor').integrityStatus, 'pending_anchor');
      expect(parse('revoked').integrityStatus, 'revoked');
      expect(parse(null).integrityStatus, isEmpty);

      // An explicit flag from the payload still wins.
      expect(
        PledgeHistoryItem.fromJson({
          'isVerified': true,
          'integrityStatus': 'revoked',
        }).isVerified,
        isTrue,
      );
    });

    test('parses vouchers and emits ISO dates/default fields', () {
      final vouchers = appMockJson['vouchers'] as List<Object?>;

      for (final item in vouchers.cast<Map<String, Object?>>()) {
        final json = Voucher.fromJson(item).toJson();
        expect(json['expiresAt'], isA<String>());
        expect(DateTime.tryParse(json['expiresAt']! as String), isNotNull);
        expect(json['active'], isA<bool>());
        expect(json['manual'], isA<bool>());
        expect(json['note'], isA<String>());
        expect(json['codeFormat'], isA<String>());
      }

      final minimal = Voucher.fromJson({
        'id': 'v-test',
        'code': 'TEST',
        'title': 'T',
        'shopId': 's-test',
        'discountValue': 10,
        'isPercent': true,
        'minSpend': 0,
        'expiresAt': '2026-06-01T00:00:00Z',
      });
      expect(minimal.isActive, isTrue);
      expect(minimal.isManual, isFalse);
      expect(minimal.note, isEmpty);
      expect(minimal.codeFormat, 'QR');

      final invalidDate = Voucher.fromJson({
        'id': 'v-invalid',
        'code': 'BADDATE',
        'title': 'T',
        'shopId': 's-test',
        'discountValue': 10,
        'isPercent': true,
        'minSpend': 0,
        'expiresAt': 'not-a-date',
      });
      expect(invalidDate.expiresAt, DateTime.fromMillisecondsSinceEpoch(0));
    });

    test('parses user vouchers and emits nullable ISO usedAt', () {
      final userVouchers = appMockJson['userVouchers'] as List<Object?>;

      for (final item in userVouchers.cast<Map<String, Object?>>()) {
        final json = UserVoucher.fromJson(item).toJson();
        expect(json['used'], isA<bool>());
        if (json['usedAt'] != null) {
          expect(json['usedAt'], isA<String>());
          expect(DateTime.tryParse(json['usedAt']! as String), isNotNull);
        }
      }

      final minimal = UserVoucher.fromJson({
        'id': 'uv-test',
        'userEmail': 'demo@example.com',
        'voucherId': 'v-test',
      });
      expect(minimal.isUsed, isFalse);
      expect(minimal.usedAt, isNull);

      final invalidDate = UserVoucher.fromJson({
        'id': 'uv-invalid',
        'userEmail': 'demo@example.com',
        'voucherId': 'v-test',
        'usedAt': 'not-a-date',
      });
      expect(invalidDate.usedAt, DateTime.fromMillisecondsSinceEpoch(0));
    });

    test('parses last buyer check', () {
      final item = appMockJson['lastBuyerCheck'] as Map<String, Object?>;
      final json = BuyerCheckResult.fromJson(item).toJson();

      expect(
        json.keys,
        containsAll(<String>['actualScore', 'locationStatus', 'verdict']),
      );
    });

    test('rejects snake_case and missing required keys', () {
      expect(
        () => Product.fromJson({
          'id': 'p-test',
          'shop_id': 's-test',
          'name': 'N',
          'description': 'D',
          'category': 'C',
          'freshnessScore': 90,
          'freshnessNote': 'F',
          'price': 1,
          'tags': <String>[],
          'status': 'Published',
        }),
        throwsA(isA<TypeError>()),
      );

      expect(
        () => Shop.fromJson({'id': 's-test', 'name': 'N'}),
        throwsA(isA<TypeError>()),
      );

      expect(
        () => Voucher.fromJson({'id': 'v-test'}),
        throwsA(isA<TypeError>()),
      );

      expect(
        () => UserVoucher.fromJson({'id': 'uv-test'}),
        throwsA(isA<TypeError>()),
      );

      expect(
        () => BuyerCheckResult.fromJson({'actualScore': 90}),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
