import 'package:flutter/material.dart';

import 'package:vngrocery/core/utils/currency_formatter.dart';
import 'package:vngrocery/core/widgets/product_thumbnail.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/home/category_presenter.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onMore;
  final VoidCallback onOpenHistory;
  final VoidCallback onCreatePledge;

  const SellerProductCard({
    super.key,
    required this.product,
    required this.onMore,
    required this.onOpenHistory,
    required this.onCreatePledge,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Card(
      color: palette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                // Was a fixed grey icon, so a seller's own listings looked
                // pictureless to them while buyers saw the photo they had
                // uploaded.
                ProductThumbnail(imageUrls: product.imageUrls, size: 60),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        // The same presenter the buyer side uses. The seller
                        // had its own list of categories - beef, pork,
                        // chicken - which the server has never used, so every
                        // real category fell through it and the shopkeeper was
                        // shown the raw key: "Danh mục: vegetables".
                        l10n.sellerProductCategoryValue(
                          CategoryPresenter.label(l10n, product.category),
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: context.palette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          SellerProductStatusBadge(status: product.status),
                          const SizedBox(width: 8),
                          // The price was on none of these cards, which is an
                          // odd thing to hide from the person who sets it.
                          Flexible(
                            child: Text(
                              formatCurrencyVnd(product.price),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.priceRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: context.palette.textSecondary),
                  onPressed: onMore,
                ),
              ],
            ),
            Divider(height: 24, thickness: 0.5, color: palette.border),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onOpenHistory,
                    icon: const Icon(Icons.history, size: 16),
                    label: Text(
                      l10n.sellerProductHistoryShort,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onCreatePledge,
                    icon: const Icon(Icons.verified_user, size: 16),
                    label: Text(
                      l10n.sellerProductAddPledgeShort,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SellerProductList extends StatelessWidget {
  final List<Product> products;
  final double bottomContentInset;
  final ValueChanged<Product> onMore;
  final ValueChanged<Product> onOpenHistory;
  final ValueChanged<Product> onCreatePledge;

  const SellerProductList({
    super.key,
    required this.products,
    required this.bottomContentInset,
    required this.onMore,
    required this.onOpenHistory,
    required this.onCreatePledge,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // AlwaysScrollable so a wrapping RefreshIndicator can be pulled even
      // when the list is short enough to fit without scrolling.
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomContentInset),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final product = products[index];
        return SellerProductCard(
          product: product,
          onMore: () => onMore(product),
          onOpenHistory: () => onOpenHistory(product),
          onCreatePledge: () => onCreatePledge(product),
        );
      },
    );
  }
}

class SellerProductStatusBadge extends StatelessWidget {
  final String status;

  const SellerProductStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bg = SellerProductPresenter.statusBackground(context, status);
    final fg = SellerProductPresenter.statusForeground(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        SellerProductPresenter.stateLabel(status, l10n),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}
