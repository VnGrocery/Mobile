import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/stores/controllers/store_detail_cubit.dart';
import 'package:vngrocery/utils/format.dart';
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
                  formatShortDate(review.date),
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
  final bool canWriteReview;

  const StoreReviewList({
    super.key,
    required this.shopId,
    required this.reviews,
    required this.canWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final review in reviews) StoreReviewItem(review: review),
        if (canWriteReview)
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    Routes.review,
                    // ReviewArgs, not StoreDetailArgs: the route only accepts
                    // its own type or a bare string, so the wrong one fell
                    // through to the fallback and bounced the user home.
                    arguments: ReviewArgs(shopId),
                  );
                  if (!context.mounted) return;
                  // The screen loaded once in initState, so a review written
                  // here never showed up until the shop was reopened. Reloading
                  // also refreshes the rating average, which the review changed.
                  await context.read<StoreDetailCubit>().load(shopId);
                },
                child: Text(
                  AppLocalizations.of(context).storeDetailWriteReview,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
