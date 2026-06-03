import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/core/storage/cache_policy.dart';

class CartItem {
  final String productId;
  final String shopId;
  final String name;
  final int price;
  final int quantity;
  final String imageAsset;
  final String? appliedVoucherId;
  final DateTime addedAt;

  const CartItem({
    required this.productId,
    required this.shopId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageAsset = 'assets/images/lamb_meat.png',
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
      imageAsset:
          json['imageAsset'] as String? ?? 'assets/images/lamb_meat.png',
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
    String? imageAsset,
    String? appliedVoucherId,
    DateTime? addedAt,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageAsset: imageAsset ?? this.imageAsset,
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
        'imageAsset': imageAsset,
        'appliedVoucherId': appliedVoucherId,
        'addedAt': addedAt.toIso8601String(),
      };
}
