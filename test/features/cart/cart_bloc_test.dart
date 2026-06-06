import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
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

    test('groups products by shop and sums grand total', () async {
      final bloc = CartBloc(cartRepository: _MemoryCartStorage());

      bloc.add(CartAddRequested(product: _product));
      await bloc.stream.first;
      bloc.add(CartAddRequested(product: _otherShopProduct));

      await expectLater(
        bloc.stream,
        emits(
          predicate<CartState>(
            (state) =>
                state.itemsByShop.keys.length == 2 &&
                state.shopSubtotal('s1') == 250000 &&
                state.shopSubtotal('s2') == 85000 &&
                state.grandTotal == 335000,
          ),
        ),
      );
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

    test('applies voucher for the matching shop', () async {
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
                state.shopDiscount('s1') == 50000 &&
                state.shopTotal('s1') == 200000 &&
                state.appliedVouchersByShop['s1']?.id == 'v-test',
          ),
        ),
      );
      await bloc.close();
    });

    test('does not discount when voucher belongs to another shop', () async {
      final bloc = CartBloc(cartRepository: _MemoryCartStorage());

      bloc.add(CartAddRequested(product: _product));
      await bloc.stream.first;
      bloc.add(CartVoucherApplied(shopId: 's1', voucher: _otherShopVoucher));

      await expectLater(
        bloc.stream,
        emits(
          predicate<CartState>(
            (state) =>
                state.shopDiscount('s1') == 0 &&
                state.shopTotal('s1') == 250000,
          ),
        ),
      );
      await bloc.close();
    });

    test('drops items older than 24 hours on start', () async {
      final storage = _MemoryCartStorage(
        savedItems: [
          CartItem.fromProduct(
            _product,
          ).copyWith(
              addedAt: DateTime.now().subtract(const Duration(hours: 25))),
          CartItem.fromProduct(_otherShopProduct),
        ],
      );
      final bloc = CartBloc(cartRepository: storage);

      bloc.add(const CartStarted());

      await expectLater(
        bloc.stream,
        emits(
          predicate<CartState>(
            (state) =>
                state.itemCount == 1 &&
                state.items.single.productId == _otherShopProduct.id,
          ),
        ),
      );
      expect(storage.savedItems.length, 1);
      await bloc.close();
    });

    test('drops stale applied voucher ids on start', () async {
      final storage = _MemoryCartStorage()
        ..savedItems = [CartItem.fromProduct(_product)]
        ..savedVoucherIdsByShop = {'s1': 'missing-voucher'};
      final bloc = CartBloc(cartRepository: storage);

      bloc.add(const CartStarted());

      await expectLater(
        bloc.stream,
        emits(
          predicate<CartState>(
            (state) =>
                state.itemCount == 1 &&
                state.appliedVouchersByShop.isEmpty &&
                state.shopNameOrNull('s1') != null,
          ),
        ),
      );
      expect(storage.savedVoucherIdsByShop, isEmpty);
      await bloc.close();
    });

    test('keeps cart stable when a cached item shop no longer exists', () async {
      final missingShopProduct = Product(
        id: 'p-missing-shop',
        shopId: 'missing-shop',
        name: 'Hàng mồ côi',
        description: 'Demo',
        category: 'Khác',
        freshnessScore: 50,
        freshnessNote: 'Không rõ',
        price: 12000,
        tags: const ['Demo'],
        status: 'Published',
      );
      final storage = _MemoryCartStorage(
        savedItems: [CartItem.fromProduct(missingShopProduct)],
      );
      final bloc = CartBloc(cartRepository: storage);

      bloc.add(const CartStarted());

      await expectLater(
        bloc.stream,
        emits(
          predicate<CartState>(
            (state) =>
                state.itemCount == 1 &&
                state.shopNameOrNull('missing-shop') == null &&
                state.hasMissingShopData,
          ),
        ),
      );
      await bloc.close();
    });

    test('removes orphan voucher entries when last shop item disappears', () async {
      final storage = _MemoryCartStorage();
      final bloc = CartBloc(cartRepository: storage);

      bloc.add(CartAddRequested(product: _product));
      await bloc.stream.first;
      bloc.add(CartVoucherApplied(shopId: 's1', voucher: _voucher));
      await bloc.stream.first;
      bloc.add(const CartRemoveRequested('p-test'));

      await expectLater(
        bloc.stream,
        emits(
          predicate<CartState>(
            (state) =>
                state.isEmpty &&
                state.appliedVouchersByShop.isEmpty &&
                state.shopsById.isEmpty,
          ),
        ),
      );
      expect(storage.savedVoucherIdsByShop, isEmpty);
      await bloc.close();
    });

    test('loads legacy cache items without addedAt', () {
      final item = CartItem.fromJson({
        'productId': 'legacy-p',
        'shopId': 's1',
        'name': 'Legacy item',
        'price': 10000,
        'quantity': 1,
      });

      expect(item.productId, 'legacy-p');
      expect(item.addedAt, isA<DateTime>());
    });

    test('clears cart', () async {
      final storage = _MemoryCartStorage();
      final bloc = CartBloc(cartRepository: storage);

      bloc.add(CartAddRequested(product: _product));
      await bloc.stream.first;
      bloc.add(const CartCleared());

      await expectLater(
        bloc.stream,
        emits(predicate<CartState>((state) => state.isEmpty)),
      );
      expect(storage.cleared, isTrue);
      await bloc.close();
    });
  });

  group('CartRepository', () {
    late Directory tempDir;
    late Box<Map> box;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('cart_repository_test_');
      Hive.init(tempDir.path);
      box = await Hive.openBox<Map>(
        'cart_test_${DateTime.now().microsecondsSinceEpoch}',
      );
    });

    tearDown(() async {
      await box.deleteFromDisk();
      await Hive.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('filters stale applied voucher cache rows', () async {
      await box.put('cart_state', {
        'appliedVoucherIdsByShop': {
          'shop-1': 'voucher-1',
          7: 'bad-shop',
          'shop-2': null,
          '': 'bad-empty-shop',
          'shop-3': '',
        },
      });

      final repository = CartRepository(box: box);

      expect(repository.loadAppliedVoucherIdsByShop(), {
        'shop-1': 'voucher-1',
      });
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

final _otherShopProduct = Product(
  id: 'p-other',
  shopId: 's2',
  name: 'Ức gà test',
  description: 'Demo',
  category: 'Thịt gà',
  freshnessScore: 88,
  freshnessNote: 'Tươi',
  price: 85000,
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

final _otherShopVoucher = Voucher(
  id: 'v-other',
  code: 'OTHER20',
  title: 'Giảm 20%',
  shopId: 's2',
  discountValue: 20,
  isPercent: true,
  minSpend: 100000,
  expiresAt: DateTime(2026, 12, 31),
);

class _MemoryCartStorage implements CartStorage {
  _MemoryCartStorage({
    this.savedItems = const [],
  });

  List<CartItem> savedItems;
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
