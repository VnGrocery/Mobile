import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/cart/models/cart_item.dart';
import 'package:vngrocery/features/cart/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartStorage _cartRepository;
  final AppRepositories _appRepositories;

  CartBloc({
    CartStorage? cartRepository,
    AppRepositories? appRepositories,
  })  : _cartRepository = cartRepository ?? CartRepository(),
        _appRepositories = appRepositories ?? AppRepositories.instance,
        super(const CartState.initial()) {
    on<CartStarted>(_onStarted);
    on<CartAddRequested>(_onAddRequested);
    on<CartQuantityChanged>(_onQuantityChanged);
    on<CartRemoveRequested>(_onRemoveRequested);
    on<CartVoucherApplied>(_onVoucherApplied);
    on<CartVoucherChecked>(_onVoucherChecked);
    on<CartVoucherRemoved>(_onVoucherRemoved);
    on<CartCleared>(_onCleared);
  }

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    final now = DateTime.now();
    final items = _cartRepository
        .loadItems()
        .where((item) => !item.isExpired(now))
        .toList();
    final voucherIdsByShop = _cartRepository.loadAppliedVoucherIdsByShop();
    final vouchersByShop = <String, Voucher>{};
    for (final entry in voucherIdsByShop.entries) {
      if (entry.key == 'legacy') continue;
      final voucher = _appRepositories.vouchers.byIdOrNull(entry.value);
      if (voucher != null && voucher.shopId == entry.key) {
        vouchersByShop[entry.key] = voucher;
      }
    }
    emit(
      CartState(
        items: items,
        appliedVouchersByShop: vouchersByShop,
        isRestored: true,
      ),
    );
    await _cartRepository.saveCart(
      items: items,
      appliedVoucherIdsByShop: _voucherIds(vouchersByShop),
    );
  }

  Future<void> _onAddRequested(
    CartAddRequested event,
    Emitter<CartState> emit,
  ) async {
    final items = [...state.items];
    final index =
        items.indexWhere((item) => item.productId == event.product.id);
    if (index >= 0) {
      final current = items[index];
      items[index] = current.copyWith(
        quantity: current.quantity + event.quantity,
      );
    } else {
      items.add(CartItem.fromProduct(event.product, quantity: event.quantity));
    }
    await _emitAndPersist(emit, state.copyWith(items: items));
  }

  Future<void> _onQuantityChanged(
    CartQuantityChanged event,
    Emitter<CartState> emit,
  ) async {
    final items = state.items
        .map(
          (item) => item.productId == event.productId
              ? item.copyWith(quantity: event.quantity)
              : item,
        )
        .where((item) => item.quantity > 0)
        .toList();
    await _emitAndPersist(emit, state.copyWith(items: items));
  }

  Future<void> _onRemoveRequested(
    CartRemoveRequested event,
    Emitter<CartState> emit,
  ) async {
    final items =
        state.items.where((item) => item.productId != event.productId).toList();
    await _emitAndPersist(emit, state.copyWith(items: items));
  }

  Future<void> _onVoucherApplied(
    CartVoucherApplied event,
    Emitter<CartState> emit,
  ) async {
    await _emitAndPersist(
      emit,
      state.copyWith(
        appliedVouchersByShop: {
          ...state.appliedVouchersByShop,
          event.shopId: event.voucher,
        },
      ),
    );
  }

  Future<void> _onVoucherChecked(
    CartVoucherChecked event,
    Emitter<CartState> emit,
  ) async {
    final result = _appRepositories.vouchers.check(
      code: event.code,
      shopId: event.shopId,
      orderValue: state.shopSubtotal(event.shopId),
    );
    final voucher = result.voucher;
    if (!result.valid || voucher == null) return;
    add(CartVoucherApplied(shopId: event.shopId, voucher: voucher));
  }

  Future<void> _onVoucherRemoved(
    CartVoucherRemoved event,
    Emitter<CartState> emit,
  ) async {
    final vouchers = {...state.appliedVouchersByShop}..remove(event.shopId);
    await _emitAndPersist(
      emit,
      state.copyWith(appliedVouchersByShop: vouchers),
    );
  }

  Future<void> _onCleared(CartCleared event, Emitter<CartState> emit) async {
    await _cartRepository.clearCart();
    emit(const CartState(items: [], isRestored: true));
  }

  Future<void> _emitAndPersist(Emitter<CartState> emit, CartState next) async {
    emit(next);
    await _cartRepository.saveCart(
      items: next.items,
      appliedVoucherIdsByShop: _voucherIds(next.appliedVouchersByShop),
    );
  }

  Map<String, String> _voucherIds(Map<String, Voucher> vouchersByShop) {
    return vouchersByShop
        .map((shopId, voucher) => MapEntry(shopId, voucher.id));
  }
}
