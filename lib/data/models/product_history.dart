import 'json_helpers.dart';

/// One field a recorded change altered.
class FieldChange {
  /// Server-side field name, e.g. `price`. Translated for display.
  final String field;
  final String before;
  final String after;

  const FieldChange({
    required this.field,
    required this.before,
    required this.after,
  });

  factory FieldChange.fromJson(Map<String, Object?> json) => FieldChange(
    field: json['field']?.toString() ?? '',
    before: json['before']?.toString() ?? '',
    after: json['after']?.toString() ?? '',
  );
}

/// One recorded change to a product.
///
/// The server keeps every mutation in a signed, hash-chained log: each entry
/// carries the SHA-256 of its own content and links to the one before it. This
/// is that entry, shaped to read like a commit.
class ProductHistoryEntry {
  /// Full hex digest.
  final String sha;

  /// First six characters, the way a commit is quoted in a list.
  final String shortSha;

  final int sequence;

  /// Server action key, e.g. `product.created`. Translated for display.
  final String action;
  final String actorName;
  final DateTime? occurredAt;

  /// True only when the content hash, the signature and the link to the
  /// previous entry all check out.
  final bool verified;
  final bool contentHashValid;
  final bool signatureValid;
  final bool chainLinkValid;

  /// Price this change left in place. Null when the entry carried no product
  /// body, such as a deletion.
  final double? priceAfter;

  final List<FieldChange> changes;

  const ProductHistoryEntry({
    required this.sha,
    required this.shortSha,
    required this.sequence,
    required this.action,
    this.actorName = '',
    this.occurredAt,
    this.verified = false,
    this.contentHashValid = false,
    this.signatureValid = false,
    this.chainLinkValid = false,
    this.priceAfter,
    this.changes = const [],
  });

  factory ProductHistoryEntry.fromJson(Map<String, Object?> json) {
    final changes = json['changes'];
    return ProductHistoryEntry(
      sha: json['sha']?.toString() ?? '',
      shortSha: json['shortSha']?.toString() ?? '',
      sequence: (json['sequence'] as num?)?.toInt() ?? 0,
      action: json['action']?.toString() ?? '',
      actorName: json['actorName']?.toString() ?? '',
      occurredAt: optionalDateTime(json['occurredAt']),
      verified: json['verified'] as bool? ?? false,
      contentHashValid: json['contentHashValid'] as bool? ?? false,
      signatureValid: json['signatureValid'] as bool? ?? false,
      chainLinkValid: json['chainLinkValid'] as bool? ?? false,
      priceAfter: (json['priceAfter'] as num?)?.toDouble(),
      changes: changes is List
          ? changes
                .whereType<Map<String, Object?>>()
                .map(FieldChange.fromJson)
                .toList()
          : const [],
    );
  }

  /// The price change this entry made, when it made one. Null for entries that
  /// only touched other fields.
  FieldChange? get priceChange {
    for (final change in changes) {
      if (change.field == 'price') return change;
    }
    return null;
  }
}

/// The price in effect at a moment.
class PricePoint {
  final DateTime at;
  final double price;

  const PricePoint({required this.at, required this.price});

  factory PricePoint.fromJson(Map<String, Object?> json) => PricePoint(
    at: dateTime(json['at']),
    price: (json['price'] as num?)?.toDouble() ?? 0,
  );
}

/// What every shop selling the same product charges for it.
///
/// Two shops count as selling the same product when the whole name and the
/// category match once folded, so different pack sizes are never averaged into
/// one misleading number.
class MarketPrice {
  /// What was treated as "the same product", so the reader can see the basis.
  final String catalogKey;

  /// Includes this shop.
  final int shopCount;

  final double currentAverage;
  final double currentLowest;
  final double currentHighest;

  /// The average price in effect across those shops, over the same window as
  /// the product's own series.
  final List<PricePoint> history;

  const MarketPrice({
    this.catalogKey = '',
    this.shopCount = 0,
    this.currentAverage = 0,
    this.currentLowest = 0,
    this.currentHighest = 0,
    this.history = const [],
  });

  /// True once there is a market to compare against. The server already omits
  /// the block when nobody else sells it, so this guards the rest.
  ///
  /// Deliberately does not require a drawable series: the count, the average
  /// and the spread are true and useful the moment a second shop lists the
  /// item, even if no time has passed since.
  bool get hasComparison => shopCount > 1 && currentAverage > 0;

  /// The shortest stretch a series has to cover before it reads as a trend.
  static const _trendSpan = Duration(days: 1);

  /// True when the average has moved over enough time to be worth plotting.
  ///
  /// Several shops listing the same item within the same second — which is
  /// what a freshly seeded catalogue looks like — produces a handful of points
  /// milliseconds apart. Drawn against a 30-day axis they collapse into a
  /// vertical stroke at the right edge that says nothing, and reads as a
  /// broken chart rather than as "no history yet".
  bool get hasTrend {
    if (history.length < 2) return false;
    final span = history.last.at.difference(history.first.at);
    return span >= _trendSpan;
  }

  /// How far this shop sits from the average, as a fraction. Negative is
  /// cheaper. Null when there is nothing to compare against.
  double? relativeTo(double price) {
    if (!hasComparison || currentAverage <= 0) return null;
    return (price - currentAverage) / currentAverage;
  }

  factory MarketPrice.fromJson(Map<String, Object?> json) {
    final points = json['history'];
    return MarketPrice(
      catalogKey: json['catalogKey']?.toString() ?? '',
      shopCount: (json['shopCount'] as num?)?.toInt() ?? 0,
      currentAverage: (json['currentAverage'] as num?)?.toDouble() ?? 0,
      currentLowest: (json['currentLowest'] as num?)?.toDouble() ?? 0,
      currentHighest: (json['currentHighest'] as num?)?.toDouble() ?? 0,
      history: points is List
          ? points
                .whereType<Map<String, Object?>>()
                .map(PricePoint.fromJson)
                .toList()
          : const [],
    );
  }
}

/// A product's recorded history and the price series derived from it.
class ProductHistory {
  final String productId;

  /// Newest first.
  final List<ProductHistoryEntry> entries;

  /// False when any entry failed verification, meaning the record has been
  /// altered since it was written. Also false when there is nothing recorded --
  /// an unverified claim and no claim are both "not proven".
  final bool chainVerified;

  final List<PricePoint> priceHistory;
  final int windowDays;

  /// What other shops charge for the same product. Null when none do.
  final MarketPrice? market;

  const ProductHistory({
    required this.productId,
    this.entries = const [],
    this.chainVerified = false,
    this.priceHistory = const [],
    this.windowDays = 30,
    this.market,
  });

  /// Nothing recorded at all, which is what a product created before the log
  /// existed looks like.
  bool get isEmpty => entries.isEmpty;

  /// True once the price has actually moved; a flat line from a single point
  /// is not a chart worth drawing.
  bool get hasPriceMovement {
    if (priceHistory.length < 2) return false;
    final first = priceHistory.first.price;
    return priceHistory.any((point) => point.price != first);
  }

  double get lowestPrice =>
      priceHistory.map((p) => p.price).reduce((a, b) => a < b ? a : b);

  double get highestPrice =>
      priceHistory.map((p) => p.price).reduce((a, b) => a > b ? a : b);

  factory ProductHistory.fromJson(Map<String, Object?> json) {
    final entries = json['entries'];
    final points = json['priceHistory'];
    return ProductHistory(
      productId: json['productId']?.toString() ?? '',
      entries: entries is List
          ? entries
                .whereType<Map<String, Object?>>()
                .map(ProductHistoryEntry.fromJson)
                .toList()
          : const [],
      chainVerified: json['chainVerified'] as bool? ?? false,
      priceHistory: points is List
          ? points
                .whereType<Map<String, Object?>>()
                .map(PricePoint.fromJson)
                .toList()
          : const [],
      windowDays: (json['windowDays'] as num?)?.toInt() ?? 30,
      market: json['market'] is Map<String, Object?>
          ? MarketPrice.fromJson(json['market'] as Map<String, Object?>)
          : null,
    );
  }
}
