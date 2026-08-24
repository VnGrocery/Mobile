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
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
        // What the seller says the goods are. It was collected on the create
        // and edit forms, stored, and written into the signed change log -
        // and then never shown to the one person it was written for.
        if (product.description.trim().isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            product.description.trim(),
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: context.palette.textSecondary,
            ),
          ),
        ],
        // The shop's product list has always shown these; the page the buyer
        // opens from it did not.
        if (product.tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final tag in product.tags)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.palette.mutedSurface,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.palette.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ],
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
    final palette = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: palette.textSecondary),
        const SizedBox(width: 4),
        // A long shop name used to push this row past the card edge before the
        // surrounding Wrap ever got a chance to break the line.
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: palette.textSecondary),
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
                  style: TextStyle(
                    fontSize: 11,
                    color: context.palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ScoreRingBadge(
            score: score,
            size: 56,
            scoreFontSize: 20,
            labelFontSize: 11,
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
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            // The real check lives in the scanner: read the bundle code, then
            // photograph the product. The old screen scored a bundled image
            // against the seller's own in-memory payload.
            onPressed: () => Navigator.pushNamed(context, Routes.scan),
            // Was a black fill - a third button style the design system does
            // not have, on the button that performs the verification this
            // whole screen exists for.
            style: FilledButton.styleFrom(
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
            style: TextStyle(
              fontSize: 12,
              color: context.palette.textSecondary,
            ),
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

/// What the product page shows when the signed log could not be read.
///
/// The section used to disappear, which made an unreachable server look
/// exactly like a product nobody has ever changed - the one thing this app
/// must never say by accident.
class ProductHistoryUnavailable extends StatelessWidget {
  final VoidCallback onRetry;

  const ProductHistoryUnavailable({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.cloud_off,
                size: 18,
                color: AppColors.warningText,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.productHistoryUnavailableTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.productHistoryUnavailableBody,
            style: TextStyle(
              fontSize: 13,
              color: palette.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onRetry,
              child: Text(l10n.homeRetryAction),
            ),
          ),
        ],
      ),
    );
  }
}
