import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories.dart';
import '../models/cart_item.dart';
import '../repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  final AppRepositories _appRepositories;

  CartBloc({
    CartRepository? cartRepository,
    AppRepositories? appRepositories,
  })  : _cartRepository = cartRepository ?? CartRepository(),
        _appRepositories = appRepositories ?? AppRepositories.instance,
        super(const CartState.initial()) {
    on<CartStarted>(_onStarted);
    on<CartAddRequested>(_onAddRequested);
    on<CartQuantityChanged>(_onQuantityChanged);
    on<CartRemoveRequested>(_onRemoveRequested);
    on<CartVoucherApplied>(_onVoucherApplied);
    on<CartCleared>(_onCleared);
  }

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    final items = _cartRepository.loadItems();
    final voucherId = _cartRepository.loadAppliedVoucherId();
    final voucher =
        voucherId == null ? null : _appRepositories.vouchers.byId(voucherId);
    emit(
      CartState(
        items: items,
        appliedVoucher: voucher,
        appliedVoucherId: voucherId,
        isRestored: true,
      ),
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
        appliedVoucher: event.voucher,
        appliedVoucherId: event.voucher.id,
      ),
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
      appliedVoucherId: next.appliedVoucherId,
    );
  }
}
