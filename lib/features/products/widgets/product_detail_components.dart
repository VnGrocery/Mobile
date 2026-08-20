import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';
import 'package:vngrocery/widgets/common.dart';
import 'package:vngrocery/widgets/score_badge.dart';

class ProductHeroImage extends StatelessWidget {
  const ProductHeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          color: palette.card,
          alignment: Alignment.center,
          child: Icon(Icons.image, size: 100, color: palette.textTertiary),
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

  const ProductTitleBlock({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
        color: AppColors.meatRed.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.meatRed.withValues(alpha: 0.2)),
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
                    color: AppColors.meatRed,
                  ),
                ),
                Text(
                  l10n.productDetailLatestScoreSubtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
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
            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
