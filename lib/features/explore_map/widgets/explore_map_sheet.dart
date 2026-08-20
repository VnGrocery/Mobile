import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

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

  /// True while the app is still finding the reader. The list is headed "near
  /// you", so until there is a "you" it would be labelling shops on the far
  /// side of the country as nearby.
  final bool locating;

  const ExploreMapBottomSheet({
    super.key,
    required this.controller,
    required this.shops,
    required this.selectedShopId,
    required this.onSelectShop,
    required this.selectedShop,
    required this.bottomContentInset,
    this.locating = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              Expanded(
                child: Text(
                  l10n.exploreNearbyTitle,
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
                  child: Text(l10n.exploreViewStore),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (locating)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Text(
                  l10n.mapLocatingTitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else if (shops.isEmpty)
            // A bare heading over empty space reads as a list that failed to
            // load rather than as an answer.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Text(
                    l10n.homeNoShopNearbyTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeNoShopNearbyMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
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
