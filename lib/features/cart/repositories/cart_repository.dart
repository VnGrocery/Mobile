import 'package:hive/hive.dart';

import '../../../core/storage/hive_storage_service.dart';
import '../models/cart_item.dart';

class CartRepository {
  static const _stateKey = 'cart_state';

  final Box<Map> _box;

  CartRepository({Box<Map>? box}) : _box = box ?? HiveStorageService.cartBox();

  List<CartItem> loadItems() {
    final data = _box.get(_stateKey);
    if (data == null) return const [];
    final rawItems = data['items'] as List?;
    if (rawItems == null) return const [];
    return rawItems
        .whereType<Map>()
        .map((item) => CartItem.fromJson(item.cast<String, Object?>()))
        .toList();
  }

  String? loadAppliedVoucherId() {
    final data = _box.get(_stateKey);
    return data?['appliedVoucherId'] as String?;
  }

  Future<void> saveCart({
    required List<CartItem> items,
    String? appliedVoucherId,
  }) {
    return _box.put(_stateKey, {
      'items': items.map((item) => item.toJson()).toList(),
      'appliedVoucherId': appliedVoucherId,
    });
  }

  Future<void> clearCart() => _box.delete(_stateKey);
}
