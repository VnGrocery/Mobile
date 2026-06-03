import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/cart/controllers/cart_bloc.dart';
import 'package:vngrocery/features/cart/controllers/cart_event.dart';
import 'package:vngrocery/features/cart/controllers/cart_state.dart';
import 'package:vngrocery/features/cart/models/cart_item.dart';
import 'package:vngrocery/features/cart/repositories/cart_repository.dart';

void main() {
  group('CartBloc', () {
    test('adds products and increases quantity for duplicate items', () async {
      final storage = _MemoryCartStorage();
      final bloc = CartBloc(cartRepository: storage);

      bloc.add(CartAddRequested(product: _product));
      await expectLater(
        bloc.stream,
        emits(
          predicate<CartState>(
            (state) => state.itemCount == 1 && state.total == 250000,
          ),
        ),
      );

      bloc.add(CartAddRequested(product: _product));
      await expectLater(
        bloc.stream,
        emits(
          predicate<CartState>(
            (state) => state.itemCount == 2 && state.total == 500000,
          ),
        ),
      );

      expect(storage.savedItems.single.quantity, 2);
      await bloc.close();
    });

    test('removes item when quantity changes to zero', () async {
      final bloc = CartBloc(cartRepository: _MemoryCartStorage());

      bloc.add(CartAddRequested(product: _product));
      await bloc.stream.first;
      bloc.add(
        const CartQuantityChanged(productId: 'p-test', quantity: 0),
      );

      await expectLater(
        bloc.stream,
        emits(predicate<CartState>((state) => state.isEmpty)),
      );
      await bloc.close();
    });

    test('applies voucher and clears cart', () async {
      final storage = _MemoryCartStorage();
      final bloc = CartBloc(cartRepository: storage);

      bloc.add(CartAddRequested(product: _product));
      await bloc.stream.first;
      bloc.add(CartVoucherApplied(shopId: 's1', voucher: _voucher));

      await expectLater(
        bloc.stream,
        emits(
          predicate<CartState>(
            (state) =>
                state.discountAmount == 50000 &&
                state.total == 200000 &&
                state.appliedVouchersByShop['s1']?.id == 'v-test',
          ),
        ),
      );

      bloc.add(const CartCleared());
      await expectLater(
        bloc.stream,
        emits(predicate<CartState>((state) => state.isEmpty)),
      );
      expect(storage.cleared, isTrue);
      await bloc.close();
    });
  });
}

final _product = Product(
  id: 'p-test',
  shopId: 's1',
  name: 'Thịt bò test',
  description: 'Demo',
  category: 'Thịt bò',
  freshnessScore: 95,
  freshnessNote: 'Tươi',
  price: 250000,
  tags: const ['Demo'],
  status: 'Published',
);

final _voucher = Voucher(
  id: 'v-test',
  code: 'SAVE20',
  title: 'Giảm 20%',
  shopId: 's1',
  discountValue: 20,
  isPercent: true,
  minSpend: 100000,
  expiresAt: DateTime(2026, 12, 31),
);

class _MemoryCartStorage implements CartStorage {
  List<CartItem> savedItems = const [];
  Map<String, String> savedVoucherIdsByShop = const {};
  bool cleared = false;

  @override
  Future<void> clearCart() async {
    cleared = true;
    savedItems = const [];
    savedVoucherIdsByShop = const {};
  }

  @override
  Map<String, String> loadAppliedVoucherIdsByShop() => savedVoucherIdsByShop;

  @override
  List<CartItem> loadItems() => savedItems;

  @override
  Future<void> saveCart({
    required List<CartItem> items,
    required Map<String, String> appliedVoucherIdsByShop,
  }) async {
    savedItems = items;
    savedVoucherIdsByShop = appliedVoucherIdsByShop;
  }
}
