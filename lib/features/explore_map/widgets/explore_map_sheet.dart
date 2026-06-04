import 'package:flutter/material.dart';

import 'package:vngrocery/core/ui/app_sheet.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class ExploreMapBottomSheet extends StatelessWidget {
  final ScrollController controller;
  final List<Shop> shops;
  final String? selectedShopId;
  final ValueChanged<Shop> onSelectShop;
  final Shop? selectedShop;
  final double bottomContentInset;

  const ExploreMapBottomSheet({
    super.key,
    required this.controller,
    required this.shops,
    required this.selectedShopId,
    required this.onSelectShop,
    required this.selectedShop,
    required this.bottomContentInset,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.elevatedCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        controller: controller,
        padding: EdgeInsets.fromLTRB(16, 10, 16, 24 + bottomContentInset),
        children: [
          const Center(child: AppSheetHandle()),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Cửa hàng gần bạn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (selectedShop != null)
                FilledButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.storeDetail,
                    arguments: StoreDetailArgs(selectedShop!.id),
                  ),
                  child: const Text('Xem cửa hàng'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final shop in shops)
            ExploreMapShopTile(
              shop: shop,
              selected: shop.id == selectedShopId,
              onTap: () => onSelectShop(shop),
            ),
        ],
      ),
    );
  }
}

class ExploreMapShopTile extends StatelessWidget {
  final Shop shop;
  final bool selected;
  final VoidCallback onTap;

  const ExploreMapShopTile({
    super.key,
    required this.shop,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? palette.positiveBg : palette.card,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: palette.elevatedCard,
                  child: Icon(
                    selected ? Icons.place : Icons.storefront,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        shop.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 15,
                      color: AppColors.warningOrange,
                    ),
                    Text(
                      ' ${shop.rating}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
