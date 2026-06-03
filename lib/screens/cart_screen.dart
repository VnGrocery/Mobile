import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/cart/controllers/cart_bloc.dart';
import '../features/cart/controllers/cart_event.dart';
import '../features/cart/controllers/cart_state.dart';
import '../features/cart/widgets/cart_expiry_banner.dart';
import '../features/cart/widgets/cart_shop_group_card.dart';
import '../features/cart/widgets/cart_summary_bar.dart';
import '../theme/app_palette.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: const Text('Giỏ tính tiền'),
        actions: [
          IconButton(
            tooltip: 'Xóa giỏ',
            onPressed: () => context.read<CartBloc>().add(const CartCleared()),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return const _EmptyCart();
          }
          final grouped = state.itemsByShop;
          final shopIds = grouped.keys.toList();
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const CartExpiryBanner(),
                    for (final shopId in shopIds)
                      CartShopGroupCard(
                        shopId: shopId,
                        items: grouped[shopId]!,
                        state: state,
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              CartSummaryBar(state: state),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Giỏ đang trống.\nThêm sản phẩm để tính tiền và kiểm tra voucher.',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
