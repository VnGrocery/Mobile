import 'package:flutter/material.dart';

import 'package:vngrocery/core/widgets/product_thumbnail.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/utils/format.dart';
import 'package:vngrocery/widgets/common.dart';
import 'package:vngrocery/widgets/score_badge.dart';
import 'package:vngrocery/theme/app_palette.dart';

class ProductHeroImage extends StatelessWidget {
  /// The seller's own photos. Empty draws a placeholder rather than a stock
  /// picture of something else.
  final List<String> imageUrls;

  const ProductHeroImage({super.key, this.imageUrls = const []});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Stack(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          // Was a grey box with an icon, ignoring the product's real photo
          // entirely, so a seller who uploaded one never saw it here.
          child: ProductThumbnail(
            imageUrls: imageUrls,
            size: double.infinity,
            radius: 0,
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              l10n.productDetailCounterImage,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductTitleBlock extends StatelessWidget {
  final Product product;

  /// Who is selling it. Null while the shop loads.
  final Shop? shop;

  const ProductTitleBlock({super.key, required this.product, this.shop});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final postedAt = product.createdAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        // Who and when: a listing with neither is a price floating in space.
        Wrap(
          spacing: 12,
          runSpacing: 2,
          children: [
            if (shop != null)
              _MetaLine(
                icon: Icons.storefront_outlined,
                text: l10n.productDetailSoldBy(shop!.name),
              ),
            if (postedAt != null)
              _MetaLine(
                icon: Icons.schedule,
                text: l10n.productDetailPostedAt(formatDateTime(postedAt)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.productDetailPricePerKg(formatVnd(product.price)),
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.priceRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _MetaLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class ProductScoreCard extends StatelessWidget {
  final double score;

  const ProductScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.productDetailLatestScoreTitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Text(
                  l10n.productDetailLatestScoreSubtitle,
                  style: TextStyle(fontSize: 11, color: context.palette.textSecondary),
                ),
              ],
            ),
          ),
          ScoreRingBadge(
            score: score,
            size: 56,
            scoreFontSize: 20,
            labelFontSize: 8,
          ),
        ],
      ),
    );
  }
}

class ProductCheckAction extends StatelessWidget {
  const ProductCheckAction({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            // The real check lives in the scanner: read the bundle code, then
            // photograph the product. The old screen scored a bundled image
            // against the seller's own in-memory payload.
            onPressed: () => Navigator.pushNamed(context, Routes.scan),
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.onSurface,
              foregroundColor: scheme.surface,
              minimumSize: const Size.fromHeight(56),
            ),
            icon: const Icon(Icons.photo_camera),
            label: Text(
              l10n.productDetailCheckAction,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
          child: Text(
            l10n.productDetailCheckActionHint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: context.palette.textSecondary),
          ),
        ),
      ],
    );
  }
}

class ProductCounterInfo extends StatelessWidget {
  final Product product;

  const ProductCounterInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.productDetailCounterInfoTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InfoRow(
          icon: Icons.store,
          label: l10n.productDetailShopCodeLabel,
          value: product.shopId,
        ),
        InfoRow(
          icon: Icons.description,
          label: l10n.productDetailFreshnessNoteLabel,
          value: product.freshnessNote,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              Routes.storeDetail,
              arguments: StoreDetailArgs(product.shopId),
            ),
            child: Text(l10n.productDetailViewStoreInfo),
          ),
        ),
      ],
    );
  }
}
