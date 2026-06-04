import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/utils/currency_formatter.dart';
import 'package:vngrocery/data/data_hooks.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/features/cart/controllers/cart_bloc.dart';
import 'package:vngrocery/features/cart/controllers/cart_event.dart';
import 'package:vngrocery/features/cart/controllers/cart_state.dart';
import 'package:vngrocery/features/cart/models/cart_item.dart';
import 'cart_item_row.dart';

class CartShopGroupCard extends StatefulWidget {
  final String shopId;
  final List<CartItem> items;
  final CartState state;

  const CartShopGroupCard({
    super.key,
    required this.shopId,
    required this.items,
    required this.state,
  });

  @override
  State<CartShopGroupCard> createState() => _CartShopGroupCardState();
}

class _CartShopGroupCardState extends State<CartShopGroupCard> {
  final _voucher = TextEditingController();

  @override
  void dispose() {
    _voucher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final shop = AppDataHooks.instance.getShop(widget.shopId);
    final appliedVoucher = widget.state.appliedVouchersByShop[widget.shopId];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShopHeader(shop: shop),
          const SizedBox(height: 12),
          for (final item in widget.items) ...[
            CartItemRow(item: item),
            if (item != widget.items.last) const Divider(height: 20),
          ],
          const SizedBox(height: 14),
          _VoucherInput(
            controller: _voucher,
            appliedVoucher: appliedVoucher,
            onApply: () {
              context.read<CartBloc>().add(
                    CartVoucherChecked(
                      shopId: widget.shopId,
                      code: _voucher.text,
                    ),
                  );
            },
            onRemove: () {
              _voucher.clear();
              context.read<CartBloc>().add(CartVoucherRemoved(widget.shopId));
            },
          ),
          const SizedBox(height: 12),
          _ShopTotals(shopId: widget.shopId, state: widget.state),
        ],
      ),
    );
  }
}

class _ShopHeader extends StatelessWidget {
  final Shop shop;

  const _ShopHeader({required this.shop});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.storefront, color: AppColors.primaryGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            shop.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class _VoucherInput extends StatelessWidget {
  final TextEditingController controller;
  final Voucher? appliedVoucher;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  const _VoucherInput({
    required this.controller,
    required this.appliedVoucher,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final voucher = appliedVoucher;
    if (voucher != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              'Đã áp dụng: ${voucher.code}',
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(onPressed: onRemove, child: const Text('Bỏ mã')),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Mã voucher của shop',
              prefixIcon: Icon(Icons.confirmation_number),
            ),
            onSubmitted: (_) => onApply(),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(onPressed: onApply, child: const Text('Kiểm tra')),
      ],
    );
  }
}

class _ShopTotals extends StatelessWidget {
  final String shopId;
  final CartState state;

  const _ShopTotals({required this.shopId, required this.state});

  @override
  Widget build(BuildContext context) {
    final discount = state.shopDiscount(shopId);
    return Column(
      children: [
        _TotalLine(label: 'Tạm tính', value: state.shopSubtotal(shopId)),
        _TotalLine(label: 'Voucher giảm', value: -discount),
        const Divider(height: 18),
        _TotalLine(
          label: 'Còn lại',
          value: state.shopTotal(shopId),
          strong: true,
        ),
      ],
    );
  }
}

class _TotalLine extends StatelessWidget {
  final String label;
  final int value;
  final bool strong;

  const _TotalLine({
    required this.label,
    required this.value,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: strong ? null : AppColors.textSecondary,
                fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            formatCurrencyVnd(value),
            style: TextStyle(
              color: strong ? AppColors.priceRed : null,
              fontWeight: strong ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
