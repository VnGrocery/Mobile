import 'package:vngrocery/data/models.dart';

abstract class CartEvent {
  const CartEvent();
}

class CartStarted extends CartEvent {
  const CartStarted();
}

class CartAddRequested extends CartEvent {
  final Product product;
  final int quantity;

  const CartAddRequested({required this.product, this.quantity = 1});
}

class CartQuantityChanged extends CartEvent {
  final String productId;
  final int quantity;

  const CartQuantityChanged({required this.productId, required this.quantity});
}

class CartRemoveRequested extends CartEvent {
  final String productId;

  const CartRemoveRequested(this.productId);
}

class CartVoucherApplied extends CartEvent {
  final String shopId;
  final Voucher voucher;

  const CartVoucherApplied({required this.shopId, required this.voucher});
}

class CartVoucherChecked extends CartEvent {
  final String shopId;
  final String code;

  const CartVoucherChecked({required this.shopId, required this.code});
}

class CartVoucherRemoved extends CartEvent {
  final String shopId;

  const CartVoucherRemoved(this.shopId);
}

class CartCleared extends CartEvent {
  const CartCleared();
}
