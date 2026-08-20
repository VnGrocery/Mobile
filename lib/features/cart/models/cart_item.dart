import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/models/json_helpers.dart';
import 'package:vngrocery/core/storage/cache_policy.dart';

class CartItem {
  final String productId;
  final String shopId;
  final String name;
  final int price;
  final int quantity;

  /// The product's own image, carried so the cart can show what was added.
  /// This used to be a bundled asset path, so every line showed the same photo.
  final List<String> imageUrls;
  final String? appliedVoucherId;
  final DateTime addedAt;

  const CartItem({
    required this.productId,
    required this.shopId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrls = const [],
    this.appliedVoucherId,
    required this.addedAt,
  });

  factory CartItem.fromProduct(Product product, {int quantity = 1}) {
    return CartItem(
      productId: product.id,
      shopId: product.shopId,
      name: product.name,
      price: product.price,
      quantity: quantity,
      imageUrls: product.imageUrls,
      addedAt: DateTime.now(),
    );
  }

  factory CartItem.fromJson(Map<String, Object?> json) {
    final addedAtValue = json['addedAt'];
    return CartItem(
      productId: json['productId'] as String,
      shopId: json['shopId'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      imageUrls: stringList(json['imageUrls']),
      appliedVoucherId: json['appliedVoucherId'] as String?,
      addedAt: addedAtValue is String
          ? DateTime.tryParse(addedAtValue) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  int get lineTotal => price * quantity;

  bool isExpired(DateTime now) {
    return now.difference(addedAt) >= CachePolicy.cartTtl;
  }

  CartItem copyWith({
    String? productId,
    String? shopId,
    String? name,
    int? price,
    int? quantity,
    List<String>? imageUrls,
    String? appliedVoucherId,
    DateTime? addedAt,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrls: imageUrls ?? this.imageUrls,
      appliedVoucherId: appliedVoucherId ?? this.appliedVoucherId,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, Object?> toJson() => {
    'productId': productId,
    'shopId': shopId,
    'name': name,
    'price': price,
    'quantity': quantity,
    'imageUrls': imageUrls,
    'appliedVoucherId': appliedVoucherId,
    'addedAt': addedAt.toIso8601String(),
  };
}
