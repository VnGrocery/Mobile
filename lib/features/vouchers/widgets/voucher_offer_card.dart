import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// One offer as a buyer sees it, with the button that takes it.
///
/// How many are left is printed only when the shop set a limit: a zero on an
/// unrationed offer would read as sold out. The button is the honest state
/// rather than a hopeful one - already held, all gone, or claimable.
class VoucherOfferCard extends StatelessWidget {
  final Voucher offer;
  final bool claimed;
  final bool claiming;
  final VoidCallback onClaim;

  const VoucherOfferCard({
    super.key,
    required this.offer,
    required this.claimed,
    required this.claiming,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final discount = offer.isPercent
        ? l10n.homeOfferPercent(offer.discountValue)
        : l10n.homeOfferAmount(formatVnd(offer.discountValue));

    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: palette.positiveBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_activity_outlined,
              color: palette.greenInk,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  discount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: palette.greenInk,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  offer.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, height: 1.3),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 10,
                  runSpacing: 2,
                  children: [
                    if (offer.minSpend > 0)
                      _Meta(l10n.homeOfferMinSpend(formatVnd(offer.minSpend))),
                    _Meta(
                      l10n.homeOfferExpiry(
                        formatShortDate('${offer.expiresAt}'),
                      ),
                    ),
                    // Only when the shop set a limit.
                    if (offer.limited)
                      _Meta(l10n.voucherRemaining(offer.remaining)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _ClaimButton(
            offer: offer,
            claimed: claimed,
            claiming: claiming,
            onClaim: onClaim,
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final String text;

  const _Meta(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 11, color: context.palette.textTertiary),
    );
  }
}

class _ClaimButton extends StatelessWidget {
  final Voucher offer;
  final bool claimed;
  final bool claiming;
  final VoidCallback onClaim;

  const _ClaimButton({
    required this.offer,
    required this.claimed,
    required this.claiming,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    if (claimed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: palette.greenInk),
          const SizedBox(width: 4),
          Text(
            l10n.voucherClaimed,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: palette.greenInk,
            ),
          ),
        ],
      );
    }
    if (!offer.isClaimable) {
      return Text(
        l10n.voucherSoldOut,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: palette.textTertiary,
        ),
      );
    }
    return FilledButton(
      onPressed: claiming ? null : onClaim,
      style: FilledButton.styleFrom(
        minimumSize: const Size(72, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: claiming
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(l10n.voucherClaim),
    );
  }
}
