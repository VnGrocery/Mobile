import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/cart/models/cart_item.dart';

class CartState {
  final List<CartItem> items;
  final Map<String, Voucher> appliedVouchersByShop;
  final Map<String, Shop> shopsById;
  final bool isRestored;

  const CartState({
    required this.items,
    this.appliedVouchersByShop = const {},
    this.shopsById = const {},
    this.isRestored = false,
  });

  const CartState.initial()
      : items = const [],
        appliedVouchersByShop = const {},
        shopsById = const {},
        isRestored = false;

  Shop? shopOrNull(String shopId) => shopsById[shopId];

  String? shopNameOrNull(String shopId) => shopOrNull(shopId)?.name;

  List<String> get orderedShopIds => itemsByShop.keys.toList();

  Map<String, Shop> resolveShops(Iterable<String> shopIds, Iterable<Shop> shops) {
    final next = <String, Shop>{};
    for (final shopId in shopIds) {
      final shop = shopsById[shopId];
      if (shop != null) {
        next[shopId] = shop;
        continue;
      }
      final resolved = shops.where((shop) => shop.id == shopId).firstOrNull;
      if (resolved != null) next[shopId] = resolved;
    }
    return next;
  }

  CartState withResolvedShops(Iterable<Shop> shops) {
    return copyWith(shopsById: resolveShops(itemsByShop.keys, shops));
  }

  CartState pruneOrphanVoucherShops() {
    final validShopIds = itemsByShop.keys.toSet();
    final vouchers = Map<String, Voucher>.fromEntries(
      appliedVouchersByShop.entries.where(
        (entry) => validShopIds.contains(entry.key),
      ),
    );
    final shops = Map<String, Shop>.fromEntries(
      shopsById.entries.where((entry) => validShopIds.contains(entry.key)),
    );
    if (vouchers.length == appliedVouchersByShop.length &&
        shops.length == shopsById.length) {
      return this;
    }
    return copyWith(appliedVouchersByShop: vouchers, shopsById: shops);
  }

  bool get hasMissingShopData => itemsByShop.keys.any((shopId) => !shopsById.containsKey(shopId));

  int get itemCount => items.fold(0, (total, item) => total + item.quantity);

  int get subtotal => items.fold(0, (total, item) => total + item.lineTotal);

  Map<String, List<CartItem>> get itemsByShop {
    final grouped = <String, List<CartItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.shopId, () => []).add(item);
    }
    return grouped;
  }

  int shopSubtotal(String shopId) {
    return itemsByShop[shopId]
            ?.fold<int>(0, (total, item) => total + item.lineTotal) ??
        0;
  }

  int shopDiscount(String shopId) {
    final subtotal = shopSubtotal(shopId);
    final voucher = appliedVouchersByShop[shopId];
    if (voucher == null ||
        voucher.shopId != shopId ||
        subtotal <= 0 ||
        subtotal < voucher.minSpend) {
      return 0;
    }
    final discount = voucher.isPercent
        ? (subtotal * voucher.discountValue / 100).round()
        : voucher.discountValue;
    return discount.clamp(0, subtotal).toInt();
  }

  int shopTotal(String shopId) => shopSubtotal(shopId) - shopDiscount(shopId);

  int get discountAmount => itemsByShop.keys.fold(
        0,
        (total, shopId) => total + shopDiscount(shopId),
      );

  int get total => subtotal - discountAmount;

  int get grandSubtotal => subtotal;

  int get grandDiscount => discountAmount;

  int get grandTotal => total;

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    List<CartItem>? items,
    Map<String, Voucher>? appliedVouchersByShop,
    Map<String, Shop>? shopsById,
    bool? isRestored,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedVouchersByShop:
          appliedVouchersByShop ?? this.appliedVouchersByShop,
      shopsById: shopsById ?? this.shopsById,
      isRestored: isRestored ?? this.isRestored,
    );
  }
}

extension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}

