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
    });
  });
}
