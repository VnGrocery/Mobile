import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/products/product_history_copy.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/l10n/app_localizations_en.dart';
import 'package:vngrocery/l10n/app_localizations_vi.dart';

Map<String, Object?> _entry({
  String sha = 'deadbeef0102',
  int sequence = 1,
  String action = 'product.updated',
  bool verified = true,
  double? priceAfter,
  List<Map<String, Object?>> changes = const [],
}) => {
  'sha': sha,
  'shortSha': sha.substring(0, 6),
  'sequence': sequence,
  'action': action,
  'actorName': 'Rau Hữu Cơ Quận 3',
  'occurredAt': '2026-08-20T21:40:07Z',
  'verified': verified,
  'contentHashValid': verified,
  'signatureValid': verified,
  'chainLinkValid': verified,
  if (priceAfter != null) 'priceAfter': priceAfter,
  'changes': changes,
};

void main() {
  final AppLocalizations vi = AppLocalizationsVi();
  final AppLocalizations en = AppLocalizationsEn();

  group('ProductHistory.fromJson', () {
    test('reads the chain, newest first, as the server sent it', () {
      final history = ProductHistory.fromJson({
        'productId': 'p1',
        'chainVerified': true,
        'windowDays': 30,
        'entries': [
          _entry(
            sequence: 2,
            priceAfter: 72000,
            changes: [
              {'field': 'price', 'before': '68000', 'after': '72000'},
            ],
          ),
          _entry(sequence: 1, action: 'product.created', priceAfter: 68000),
        ],
        'priceHistory': [
          {'at': '2026-08-01T00:00:00Z', 'price': 68000},
          {'at': '2026-08-20T00:00:00Z', 'price': 72000},
        ],
      });

      expect(history.entries, hasLength(2));
      expect(history.entries.first.sequence, 2);
      expect(history.chainVerified, isTrue);
      expect(history.priceHistory, hasLength(2));
    });

    test('a broken link anywhere means the record is not verified', () {
      final history = ProductHistory.fromJson({
        'productId': 'p1',
        'chainVerified': false,
        'entries': [_entry(verified: false)],
      });

      expect(history.chainVerified, isFalse);
      expect(history.entries.single.verified, isFalse);
    });

    test('a product with nothing recorded is empty, not broken', () {
      final history = ProductHistory.fromJson({'productId': 'p1'});

      expect(history.isEmpty, isTrue);
      expect(history.priceHistory, isEmpty);
    });

    test('finds the price change among the other fields', () {
      final entry = ProductHistoryEntry.fromJson(
        _entry(
          changes: [
            {'field': 'freshnessNote', 'before': 'a', 'after': 'b'},
            {'field': 'price', 'before': '68000', 'after': '72000'},
          ],
        ),
      );

      expect(entry.priceChange?.after, '72000');
    });
  });

  group('hasPriceMovement', () {
    ProductHistory withPrices(List<double> prices) => ProductHistory(
      productId: 'p1',
      priceHistory: [
        for (var i = 0; i < prices.length; i++)
          PricePoint(at: DateTime(2026, 8, i + 1), price: prices[i]),
      ],
    );

    test('is false for a price that never moved', () {
      // A flat line is not worth a chart; a sentence says it better.
      expect(withPrices([68000, 68000, 68000]).hasPriceMovement, isFalse);
      expect(withPrices([68000]).hasPriceMovement, isFalse);
      expect(withPrices([]).hasPriceMovement, isFalse);
    });

    test('is true as soon as it moved', () {
      expect(withPrices([68000, 72000]).hasPriceMovement, isTrue);
    });

    test('reports the range it moved over', () {
      final history = withPrices([68000, 72000, 65000]);

      expect(history.lowestPrice, 65000);
      expect(history.highestPrice, 72000);
    });
  });

  group('ProductHistoryCopy', () {
    test('translates the action keys the log records', () {
      expect(ProductHistoryCopy.action(vi, 'product.created'), 'Tạo sản phẩm');
      expect(
        ProductHistoryCopy.action(en, 'product.created'),
        'Product created',
      );
    });

    test('shows an action it does not know rather than hiding it', () {
      // It still describes a real change that really happened.
      expect(
        ProductHistoryCopy.action(vi, 'product.archived'),
        'product.archived',
      );
    });

    test('translates field names', () {
      expect(ProductHistoryCopy.field(vi, 'price'), 'Giá');
      expect(ProductHistoryCopy.field(en, 'freshnessScore'), 'Freshness score');
      expect(ProductHistoryCopy.field(vi, 'somethingNew'), 'somethingNew');
    });

    test('reads a price as money, not as the bare number stored', () {
      expect(ProductHistoryCopy.value('price', '68000'), contains('68'));
      expect(ProductHistoryCopy.value('price', '68000'), isNot('68000'));
    });

    test('leaves other fields exactly as recorded', () {
      expect(ProductHistoryCopy.value('status', 'published'), 'published');
      // A price the server did not send as a number is shown as-is.
      expect(ProductHistoryCopy.value('price', 'n/a'), 'n/a');
    });
  });

  _marketTests();
}

// --- cross-shop price comparison ---

void _marketTests() {
  MarketPrice parse(Map<String, Object?> json) => MarketPrice.fromJson(json);

  group('MarketPrice', () {
    test('reads the average, the spread and the series', () {
      final market = parse({
        'catalogKey': 'ca chua bi huu co|vegetables',
        'shopCount': 5,
        'currentAverage': 45400,
        'currentLowest': 40000,
        'currentHighest': 50000,
        'history': [
          {'at': '2026-07-22T00:00:00Z', 'price': 43000},
          {'at': '2026-08-06T00:00:00Z', 'price': 46000},
        ],
      });

      expect(market.shopCount, 5);
      expect(market.currentAverage, 45400);
      expect(market.hasComparison, isTrue);
    });

    test('one shop is not a comparison', () {
      // A line identical to the shop's own price says nothing while looking
      // like it says something.
      expect(parse({'shopCount': 1}).hasComparison, isFalse);
    });

    test('a single point is not a line', () {
      final market = parse({
        'shopCount': 3,
        'history': [
          {'at': '2026-08-01T00:00:00Z', 'price': 40000},
        ],
      });

      expect(market.hasComparison, isFalse);
    });

    test('places this shop against the average', () {
      final market = parse({
        'shopCount': 5,
        'currentAverage': 50000,
        'history': [
          {'at': '2026-07-22T00:00:00Z', 'price': 50000},
          {'at': '2026-08-06T00:00:00Z', 'price': 50000},
        ],
      });

      expect(market.relativeTo(40000), closeTo(-0.2, 0.0001));
      expect(market.relativeTo(60000), closeTo(0.2, 0.0001));
      expect(market.relativeTo(50000), 0);
    });

    test('says nothing about a price it cannot compare', () {
      expect(
        parse({'shopCount': 1, 'currentAverage': 50000}).relativeTo(40000),
        isNull,
      );
    });
  });

  group('ProductHistory.market', () {
    test('is null when no other shop sells it', () {
      final history = ProductHistory.fromJson({'productId': 'p1'});

      expect(history.market, isNull);
    });

    test('is parsed when the server sent one', () {
      final history = ProductHistory.fromJson({
        'productId': 'p1',
        'market': {'shopCount': 3, 'currentAverage': 45000},
      });

      expect(history.market?.shopCount, 3);
    });
  });
}
