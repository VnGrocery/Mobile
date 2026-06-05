import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/cart/controllers/cart_bloc.dart';
import 'package:vngrocery/features/cart/controllers/cart_event.dart';
import 'package:vngrocery/features/cart/controllers/cart_state.dart';
import 'package:vngrocery/features/cart/widgets/cart_expiry_banner.dart';
import 'package:vngrocery/features/cart/widgets/cart_shop_group_card.dart';
import 'package:vngrocery/features/cart/widgets/cart_summary_bar.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: Text(l10n.cartTitle),
        actions: [
          IconButton(
            tooltip: l10n.cartClearTooltip,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          AppLocalizations.of(context).cartEmptyBody,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
