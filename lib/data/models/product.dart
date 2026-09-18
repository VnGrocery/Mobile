import 'json_helpers.dart';

/// One row of the product's specification table.
class SpecItem {
  final String key;
  final String value;

  const SpecItem({required this.key, required this.value});

  factory SpecItem.fromJson(Map<String, Object?> json) => SpecItem(
    key: json['key'] as String? ?? '',
    value: json['value'] as String? ?? '',
  );

  Map<String, Object?> toJson() => {'key': key, 'value': value};
}

/// One block of the long-form description.
///
/// The server sends structured blocks rather than an HTML blob, so nothing
/// here needs sanitising before it is rendered and the change log can show
/// which block a seller altered.
class DescBlock {
  static const heading = 'heading';
  static const paragraph = 'paragraph';
  static const bullets = 'bullets';
  static const image = 'image';

  final String type;
  final String text;
  final List<String> items;

  /// Already a gateway URL by the time it reaches the app: the record stores
  /// a CID, and the server builds the URL the phone can actually reach.
  final String imageUrl;
  final String caption;

  const DescBlock({
    required this.type,
    this.text = '',
    this.items = const [],
    this.imageUrl = '',
    this.caption = '',
  });

  factory DescBlock.fromJson(Map<String, Object?> json) => DescBlock(
    type: json['type'] as String? ?? '',
    text: json['text'] as String? ?? '',
    items: stringList(json['items']),
    imageUrl: (json['imageUrl'] ?? json['cid']) as String? ?? '',
    caption: json['caption'] as String? ?? '',
  );

  Map<String, Object?> toJson() => {
    'type': type,
    if (text.isNotEmpty) 'text': text,
    if (items.isNotEmpty) 'items': items,
    if (imageUrl.isNotEmpty) 'cid': imageUrl,
    if (caption.isNotEmpty) 'caption': caption,
  };
}

class Product {
  final String id;
  final String shopId;
  String name;
  String description;
  String category;

  /// Freshness on the server's 0-10 scale.
  ///
  /// Was an int, which turned a 9.2 from the server into a 9 — and the score
  /// widgets read it as if it were out of 100, so every real product rendered
  /// red at 9%.
  double freshnessScore;
  String freshnessNote;
  int price;
  List<String> tags;
  String status;
  int version;
  List<String> imageUrls;

  /// Specification rows, in the order the seller arranged them.
  List<SpecItem> specs;

  /// Long-form description. Empty for a product whose text still lives in
  /// [description], which is every product created before this existed.
  List<DescBlock> descBlocks;

  /// When the seller first published it. Null for a product the server has not
  /// dated, which is the local fixture rather than anything real.
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.category,
    required this.freshnessScore,
    required this.freshnessNote,
    required this.price,
    required this.tags,
    required this.status,
    this.version = 1,
    this.imageUrls = const [],
    this.specs = const [],
    this.descBlocks = const [],
    this.createdAt,
  });

  /// A copy with one or two fields moved.
  ///
  /// The fields are mutable, but a status change is sent to the server as a
  /// whole product: editing the cached instance in place would leave the list
  /// showing the new status even when the request failed.
  Product copyWith({
    String? name,
    String? description,
    String? category,
    double? freshnessScore,
    String? freshnessNote,
    int? price,
    List<String>? tags,
    String? status,
    int? version,
    List<String>? imageUrls,
    List<SpecItem>? specs,
    List<DescBlock>? descBlocks,
  }) {
    return Product(
      id: id,
      shopId: shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      freshnessScore: freshnessScore ?? this.freshnessScore,
      freshnessNote: freshnessNote ?? this.freshnessNote,
      price: price ?? this.price,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      version: version ?? this.version,
      imageUrls: imageUrls ?? this.imageUrls,
      // Carried through even though nothing edits them yet: a copyWith that
      // quietly dropped them would wipe the seller's table on the next
      // optimistic status change.
      specs: specs ?? this.specs,
      descBlocks: descBlocks ?? this.descBlocks,
      createdAt: createdAt,
    );
  }

  factory Product.fromJson(Map<String, Object?> json) {
    return Product(
      id: (json['productId'] ?? json['id']) as String,
      shopId: json['shopId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      freshnessScore: (json['freshnessScore'] as num).toDouble(),
      freshnessNote: json['freshnessNote'] as String,
      price: (json['price'] as num).toInt(),
      tags: stringList(json['tags']),
      status: _productStatus(json['status']?.toString() ?? ''),
      version: (json['version'] as num?)?.toInt() ?? 1,
      imageUrls: stringList(json['imageUrls']),
      specs: _listOf(json['specs'], SpecItem.fromJson),
      descBlocks: _listOf(json['descBlocks'], DescBlock.fromJson),
      createdAt: optionalDateTime(json['createdAt']),
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'shopId': shopId,
    'name': name,
    'description': description,
    'category': category,
    'freshnessScore': freshnessScore,
    'freshnessNote': freshnessNote,
    'price': price,
    'tags': tags,
    'status': status,
    'version': version,
    'imageUrls': imageUrls,
    'specs': specs.map((item) => item.toJson()).toList(),
    'descBlocks': descBlocks.map((block) => block.toJson()).toList(),
  };
}

/// Absent or malformed lists come back empty rather than throwing: the app
/// talks to servers that predate these fields, and a product should still open
/// when one row of its table is wrong.
List<T> _listOf<T>(Object? value, T Function(Map<String, Object?>) parse) {
  if (value is! List) return const [];
  return value.whereType<Map<String, Object?>>().map(parse).toList();
}

String _productStatus(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
}
