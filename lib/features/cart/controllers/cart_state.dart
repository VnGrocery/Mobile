import '../../../data/models.dart';
import '../models/cart_item.dart';

class CartState {
  final List<CartItem> items;
  final Voucher? appliedVoucher;
  final String? appliedVoucherId;
  final bool isRestored;

  const CartState({
    required this.items,
    this.appliedVoucher,
    this.appliedVoucherId,
    this.isRestored = false,
  });

  const CartState.initial()
      : items = const [],
        appliedVoucher = null,
        appliedVoucherId = null,
        isRestored = false;

  int get itemCount => items.fold(0, (total, item) => total + item.quantity);

  int get subtotal => items.fold(0, (total, item) => total + item.lineTotal);

  int get discountAmount {
    final voucher = appliedVoucher;
    if (voucher == null || subtotal <= 0 || subtotal < voucher.minSpend) {
      return 0;
    }
    final discount = voucher.isPercent
        ? (subtotal * voucher.discountValue / 100).round()
        : voucher.discountValue;
    return discount.clamp(0, subtotal).toInt();
  }

  int get total => subtotal - discountAmount;

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    List<CartItem>? items,
    Voucher? appliedVoucher,
    String? appliedVoucherId,
    bool clearVoucher = false,
    bool? isRestored,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedVoucher:
          clearVoucher ? null : appliedVoucher ?? this.appliedVoucher,
      appliedVoucherId:
          clearVoucher ? null : appliedVoucherId ?? this.appliedVoucherId,
      isRestored: isRestored ?? this.isRestored,
    );
  }
}
