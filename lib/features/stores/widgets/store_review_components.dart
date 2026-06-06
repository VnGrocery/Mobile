import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class StoreReviewItem extends StatelessWidget {
  final Review review;

  const StoreReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Card(
      color: palette.card,
      elevation: 0,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 20, backgroundColor: palette.mutedSurface),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: List.generate(
                          review.rating,
                          (_) => const Icon(
                            Icons.star,
                            color: AppColors.warningOrange,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  review.date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.comment, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class StoreReviewList extends StatelessWidget {
  final String shopId;
  final List<Review> reviews;

  const StoreReviewList({
    super.key,
    required this.shopId,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final review in reviews) StoreReviewItem(review: review),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pushNamed(
                context,
                Routes.review,
                arguments: StoreDetailArgs(shopId),
              ),
              child: Text(AppLocalizations.of(context).storeDetailWriteReview),
            ),
          ),
        ),
      ],
    );
  }
}
