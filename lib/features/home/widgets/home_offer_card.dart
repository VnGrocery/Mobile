import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// The advert slot at the top of the home page.
///
/// Every offer in it is real and redeemable today - the server drops the
/// expired, the paused, and the ones whose shop is gone before the list ever
/// gets here. With several offers it rotates by swipe, which is what makes it
/// an advert slot rather than a single hardcoded banner.
class HomeOfferCard extends StatefulWidget {
  final List<FeaturedVoucher> offers;

  /// Offers the reader already holds, so the card can say so instead of
  /// inviting a claim that would do nothing.
  final Set<String> claimed;

  /// The offer a claim is in flight for.
  final String? claiming;

  final ValueChanged<FeaturedVoucher> onClaim;

  const HomeOfferCard({
    super.key,
    required this.offers,
    required this.claimed,
    required this.claiming,
    required this.onClaim,
  });

  @override
  State<HomeOfferCard> createState() => _HomeOfferCardState();
}

class _HomeOfferCardState extends State<HomeOfferCard> {
  static const _height = 150.0;

  final PageController _pages = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HomeOfferCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A shorter list can leave the dot pointing at a page that no longer
    // exists.
    if (_index >= widget.offers.length) _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    final offers = widget.offers;
    if (offers.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: _height,
          child: PageView.builder(
            controller: _pages,
            itemCount: offers.length,
            onPageChanged: (value) => setState(() => _index = value),
            padEnds: false,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: index == offers.length - 1 ? 16 : 8,
              ),
              child: _OfferTile(
                offer: offers[index],
                claimed: widget.claimed.contains(offers[index].voucher.id),
                claiming: widget.claiming == offers[index].voucher.id,
                onClaim: () => widget.onClaim(offers[index]),
              ),
            ),
          ),
        ),
        if (offers.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < offers.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 6,
                  width: i == _index ? 18 : 6,
                  decoration: BoxDecoration(
                    color: i == _index
                        ? AppColors.primaryGreen
                        : context.palette.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _OfferTile extends StatelessWidget {
  final FeaturedVoucher offer;
  final bool claimed;
  final bool claiming;
  final VoidCallback onClaim;

  const _OfferTile({
    required this.offer,
    required this.claimed,
    required this.claiming,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final voucher = offer.voucher;
    final discount = voucher.isPercent
        ? l10n.homeOfferPercent(voucher.discountValue)
        : l10n.homeOfferAmount(formatVnd(voucher.discountValue));

    return Material(
      color: AppColors.primaryGreenInk,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        // To the shop, not to a checkout: the offer is redeemed at the stall,
        // and this is where the reader can see what is being sold there.
        onTap: () => Navigator.pushNamed(
          context,
          Routes.storeDetail,
          arguments: StoreDetailArgs(voucher.shopId),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      discount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      voucher.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.storefront,
                          size: 13,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            offer.shopName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // The condition is part of the offer, not fine print to
                    // discover at the till.
                    if (voucher.minSpend > 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.homeOfferMinSpend(formatVnd(voucher.minSpend)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // The claim happens here rather than two screens away: the
                  // advert and the thing it advertises should not be separated
                  // by a navigation.
                  _ClaimControl(
                    claimed: claimed,
                    claiming: claiming,
                    claimable: voucher.isClaimable,
                    onClaim: onClaim,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    voucher.limited
                        ? l10n.voucherRemaining(voucher.remaining)
                        : l10n.homeOfferExpiry(
                            formatShortDate('${voucher.expiresAt}'),
                          ),
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClaimControl extends StatelessWidget {
  final bool claimed;
  final bool claiming;
  final bool claimable;
  final VoidCallback onClaim;

  const _ClaimControl({
    required this.claimed,
    required this.claiming,
    required this.claimable,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (claimed) {
      return Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 26),
          const SizedBox(height: 4),
          Text(
            l10n.voucherClaimed,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    if (!claimable) {
      return Text(
        l10n.voucherSoldOut,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      );
    }
    return FilledButton(
      onPressed: claiming ? null : onClaim,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryGreenInk,
        minimumSize: const Size(80, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: claiming
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              l10n.voucherClaim,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
    );
  }
}
