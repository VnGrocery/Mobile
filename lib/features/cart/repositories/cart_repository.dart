import 'package:hive/hive.dart';

import '../../../core/storage/hive_storage_service.dart';
import '../models/cart_item.dart';

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
    return rawItems
        .whereType<Map>()
        .map((item) => CartItem.fromJson(item.cast<String, Object?>()))
        .toList();
  }

  @override
  Map<String, String> loadAppliedVoucherIdsByShop() {
    final data = _box?.get(_stateKey);
    final raw = data?['appliedVoucherIdsByShop'] as Map?;
    if (raw == null) {
      final legacyVoucherId = data?['appliedVoucherId'] as String?;
      return legacyVoucherId == null ? const {} : {'legacy': legacyVoucherId};
    }
    return raw.cast<String, String>();
  }

  @override
  Future<void> saveCart({
    required List<CartItem> items,
    required Map<String, String> appliedVoucherIdsByShop,
  }) {
    final box = _box;
    if (box == null) return Future.value();
    return box.put(_stateKey, {
      'items': items.map((item) => item.toJson()).toList(),
      'appliedVoucherIdsByShop': appliedVoucherIdsByShop,
    });
  }

  @override
  Future<void> clearCart() => _box?.delete(_stateKey) ?? Future.value();
}
