import 'package:hive/hive.dart';

import 'package:vngrocery/core/storage/cache_policy.dart';
import 'package:vngrocery/core/storage/hive_storage_service.dart';
import 'package:vngrocery/features/cart/models/cart_item.dart';

abstract class CartStorage {
  List<CartItem> loadItems();
  Map<String, String> loadAppliedVoucherIdsByShop();
  Future<void> saveCart({
    required List<CartItem> items,
    required Map<String, String> appliedVoucherIdsByShop,
  });
  Future<void> clearCart();
}

class CartRepository implements CartStorage {
  static const _stateKey = 'cart_state';

  final Box<Map>? _box;

  CartRepository({Box<Map>? box})
      : _box = box ?? HiveStorageService.tryCartBox();

  @override
  List<CartItem> loadItems() {
    final data = _box?.get(_stateKey);
    if (data == null) return const [];
    final rawItems = data['items'] as List?;
    if (rawItems == null) return const [];
    final items = <CartItem>[];
    for (final rawItem in rawItems.whereType<Map>()) {
      try {
        items.add(CartItem.fromJson(rawItem.cast<String, Object?>()));
      } catch (_) {
        // Ignore stale cache rows that no longer match the cart schema.
      }
    }
    return items;
  }

  @override
  Map<String, String> loadAppliedVoucherIdsByShop() {
    final data = _box?.get(_stateKey);
    final raw = data?['appliedVoucherIdsByShop'] as Map?;
    if (raw == null) {
      final legacyVoucherId = data?['appliedVoucherId'] as String?;
      return legacyVoucherId == null ? const {} : {'legacy': legacyVoucherId};
    }
    final voucherIdsByShop = <String, String>{};
    for (final entry in raw.entries) {
      final shopId = entry.key;
      final voucherId = entry.value;
      if (shopId is String &&
          shopId.trim().isNotEmpty &&
          voucherId is String &&
          voucherId.trim().isNotEmpty) {
        voucherIdsByShop[shopId] = voucherId;
      }
    }
    return voucherIdsByShop;
  }

  @override
  Future<void> saveCart({
    required List<CartItem> items,
    required Map<String, String> appliedVoucherIdsByShop,
  }) {
    final box = _box;
    if (box == null) return Future.value();
    return box.put(_stateKey, {
      'schemaVersion': CachePolicy.cartSchemaVersion,
      'savedAt': DateTime.now().toIso8601String(),
      'expiresAfterHours': CachePolicy.cartTtl.inHours,
      'items': items.map((item) => item.toJson()).toList(),
      'appliedVoucherIdsByShop': appliedVoucherIdsByShop,
    });
  }

  @override
  Future<void> clearCart() => _box?.delete(_stateKey) ?? Future.value();
}
