import 'package:flutter/material.dart';

import 'package:vngrocery/core/widgets/product_thumbnail.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/buyer_check/verdict_copy.dart';
import 'package:vngrocery/features/seller_shop/widgets/seller_empty_state.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// The reader's own history of checks.
///
/// Nothing but standing at a stall and photographing goods puts a row in here,
/// which is why the empty state is an instruction rather than an apology: the
/// list is not missing anything, it simply has not been earned yet.
class MyChecksScreen extends StatefulWidget {
  const MyChecksScreen({super.key});

  @override
  State<MyChecksScreen> createState() => _MyChecksScreenState();
}

class _MyChecksScreenState extends State<MyChecksScreen> {
  List<MyCheck> _checks = const [];
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final remote = AppRepositories.instance.products.remote;
    if (remote == null) {
      setState(() {
        _loading = false;
        _failed = true;
      });
      return;
    }
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final checks = await remote.myChecks();
      if (!mounted) return;
      setState(() {
        _checks = checks;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: Text(
          l10n.myChecksTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _body(l10n),
      ),
    );
  }

  Widget _body(AppLocalizations l10n) {
    final bottom = 16 + MediaQuery.paddingOf(context).bottom;

    if (_failed || _checks.isEmpty) {
      // Kept scrollable so pull-to-refresh still fires over a short child.
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 40, 16, bottom),
        children: [
          if (_failed)
            SellerEmptyState(
              icon: Icons.cloud_off,
              title: l10n.myChecksFailed,
              body: l10n.commentsFailedBody,
              actionLabel: l10n.homeRetryAction,
              onAction: _load,
            )
          else
            SellerEmptyState(
              icon: Icons.qr_code_scanner,
              title: l10n.myChecksEmptyTitle,
              body: l10n.myChecksEmptyBody,
              actionLabel: l10n.myChecksEmptyAction,
              onAction: () => Navigator.pushNamed(context, Routes.scan),
            ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottom),
      itemCount: _checks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) => _CheckCard(check: _checks[index]),
    );
  }
}

class _CheckCard extends StatelessWidget {
  final MyCheck check;

  const _CheckCard({required this.check});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final pending = check.isPendingReview;
    final trusted = !pending && check.verdict == 'trusted';

    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: check.productId.isEmpty
            ? null
            : () => Navigator.pushNamed(
                context,
                Routes.productDetail,
                arguments: ProductDetailArgs(
                  shopId: check.shopId,
                  productId: check.productId,
                ),
              ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The reader's own photo, not the shop's catalogue picture. It
              // is the thing they went and did, and the only part of the row
              // they can recognise a week later.
              if (check.imageUrl.isNotEmpty) ...[
                ProductThumbnail(
                  key: const ValueKey('my_check.photo'),
                  imageUrls: [check.imageUrl],
                  size: 64,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(child: _details(l10n, palette, pending, trusted)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _details(
    AppLocalizations l10n,
    AppPalette palette,
    bool pending,
    bool trusted,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                // A product that has since been deleted keeps its place
                // in the history; only its name is gone.
                check.productName.isEmpty
                    ? l10n.commonProduct
                    : check.productName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              key: const ValueKey('my_check.badge'),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: trusted ? palette.positiveBg : palette.warningBg,
                borderRadius: BorderRadius.circular(999),
              ),
              // A pending check has no verdict to print. Printing one of
              // the scored labels here would claim the AI reached a
              // conclusion it never reached.
              child: Text(
                pending
                    ? l10n.myChecksPendingBadge
                    : VerdictCopy.label(l10n, check.verdict),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: trusted ? palette.greenInk : palette.warnInk,
                ),
              ),
            ),
          ],
        ),
        if (check.shopName.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            check.shopName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: palette.textSecondary),
          ),
        ],
        const SizedBox(height: 8),
        Text(
          // Three different situations, and they are not
          // interchangeable: nothing scored it yet, there was nothing to
          // compare against, or a comparison happened and these are the
          // two numbers.
          pending
              ? l10n.myChecksPendingBody
              : check.hasPledge
              ? l10n.myChecksScores(
                  formatRating(check.pledgedScore),
                  formatRating(check.actualScore),
                )
              : l10n.myChecksNoPledge,
          style: TextStyle(fontSize: 13, color: palette.textSecondary),
        ),
        const SizedBox(height: 6),
        Text(
          formatDateTime(check.createdAt),
          style: TextStyle(fontSize: 11, color: palette.textTertiary),
        ),
      ],
    );
  }
}
