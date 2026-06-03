import '../../../data/models.dart';
import '../models/cart_item.dart';

class CartState {
  final List<CartItem> items;
  final Map<String, Voucher> appliedVouchersByShop;
  final bool isRestored;

  const CartState({
    required this.items,
    this.appliedVouchersByShop = const {},
    this.isRestored = false,
  });

  const CartState.initial()
      : items = const [],
        appliedVouchersByShop = const {},
        isRestored = false;

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
    bool? isRestored,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedVouchersByShop:
          appliedVouchersByShop ?? this.appliedVouchersByShop,
      isRestored: isRestored ?? this.isRestored,
    );
  }
}
