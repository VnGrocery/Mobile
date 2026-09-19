import 'package:flutter/material.dart';

import 'package:vngrocery/core/widgets/product_thumbnail.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/buyer_check/buyer_check_presenter.dart';
import 'package:vngrocery/features/buyer_check/verdict_copy.dart';
import 'package:vngrocery/features/buyer_check/widgets/buyer_compare_card.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// One check the reader made, in full.
///
/// The list row only has space for a verdict and a date, which is not enough
/// to argue with: a buyer who thinks the number is wrong needs the two scores
/// side by side, the reasons behind them, and their own photo to look at
/// again. All of it came down with the list, so opening this costs no request.
class MyCheckDetailScreen extends StatelessWidget {
  final MyCheck check;

  const MyCheckDetailScreen({super.key, required this.check});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final pending = check.isPendingReview;

    return Scaffold(
      key: const ValueKey('my_check_detail.screen'),
      backgroundColor: palette.appBackground,
      appBar: AppBar(title: Text(l10n.myCheckDetailTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          if (check.imageUrl.isNotEmpty) ...[
            // The reader's own photo, at a size they can actually judge. This
            // is the evidence; everything below it is what was made of it.
            SizedBox(
              height: 220,
              width: double.infinity,
              child: ProductThumbnail(
                key: const ValueKey('my_check_detail.photo'),
                imageUrls: [check.imageUrl],
                size: double.infinity,
                radius: 12,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            check.productName.isEmpty ? l10n.commonProduct : check.productName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (check.shopName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              check.shopName,
              style: TextStyle(fontSize: 14, color: palette.textSecondary),
            ),
          ],
          const SizedBox(height: 12),
          _StatusBanner(check: check, pending: pending),
          const SizedBox(height: 16),
          // A pending check has no comparison to show. The card below would
          // print "Đo được 0.0", which is a measurement nothing took.
          if (pending)
            const _PendingNote(key: ValueKey('my_check_detail.pending'))
          else
            BuyerCompareCard(result: check.result),
          const SizedBox(height: 12),
          _FactsCard(check: check),
          const SizedBox(height: 20),
          if (check.productId.isNotEmpty)
            FilledButton.icon(
              key: const ValueKey('my_check_detail.view_product'),
              onPressed: () => Navigator.pushNamed(
                context,
                Routes.productDetail,
                arguments: ProductDetailArgs(
                  shopId: check.shopId,
                  productId: check.productId,
                ),
              ),
              icon: const Icon(Icons.storefront_outlined),
              label: Text(l10n.myCheckDetailViewProduct),
            ),
        ],
      ),
    );
  }
}

/// The one-line answer, before any of the numbers.
class _StatusBanner extends StatelessWidget {
  final MyCheck check;
  final bool pending;

  const _StatusBanner({required this.check, required this.pending});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final trusted = !pending && check.verdict == 'trusted';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: trusted ? palette.positiveBg : palette.warningBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            pending
                ? Icons.hourglass_empty
                : trusted
                ? Icons.verified
                : Icons.warning_amber,
            size: 18,
            color: trusted ? palette.greenInk : palette.warnInk,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              pending
                  ? l10n.myChecksPendingBadge
                  : VerdictCopy.label(l10n, check.verdict),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: trusted ? palette.greenInk : palette.warnInk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingNote extends StatelessWidget {
  const _PendingNote({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        AppLocalizations.of(context).myChecksPendingBody,
        style: TextStyle(fontSize: 13, color: palette.textSecondary),
      ),
    );
  }
}

/// Where, when, and against which crate.
class _FactsCard extends StatelessWidget {
  final MyCheck check;

  const _FactsCard({required this.check});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Line(
            icon: BuyerCheckPresenter.locationIcon(check.result),
            label: BuyerCheckPresenter.locationLabel(check.result, l10n),
            body: BuyerCheckPresenter.locationDescription(check.result, l10n),
          ),
          if (check.bundleId.isNotEmpty) ...[
            const SizedBox(height: 10),
            _Line(
              icon: Icons.qr_code_2,
              label: l10n.myCheckDetailLot,
              // Selectable so a buyer can quote it in a complaint.
              body: check.bundleId,
              selectableBody: true,
            ),
          ],
          const SizedBox(height: 10),
          _Line(
            icon: Icons.schedule,
            label: l10n.myCheckDetailCheckedAt,
            body: formatDateTime(check.createdAt),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final IconData icon;
  final String label;
  final String body;
  final bool selectableBody;

  const _Line({
    required this.icon,
    required this.label,
    required this.body,
    this.selectableBody = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bodyStyle = TextStyle(fontSize: 12, color: palette.textSecondary);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: palette.iconMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              selectableBody
                  ? SelectableText(body, style: bodyStyle)
                  : Text(body, style: bodyStyle),
            ],
          ),
        ),
      ],
    );
  }
}
