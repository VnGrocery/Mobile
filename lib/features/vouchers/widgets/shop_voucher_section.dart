import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/network/api_exception.dart';
import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/vouchers/controllers/shop_vouchers_cubit.dart';
import 'package:vngrocery/features/vouchers/widgets/voucher_offer_card.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// The offers a shop is running, on the shop's own page.
///
/// A shop with no offers renders nothing rather than an empty heading; a shop
/// whose offers could not be read says so, because those are different facts
/// and only one of them is about the shop.
class ShopVoucherSection extends StatelessWidget {
  const ShopVoucherSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<ShopVouchersCubit, ShopVouchersState>(
      builder: (context, state) {
        if (state.loading && state.isEmpty) return const SizedBox.shrink();
        if (!state.failed && state.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.voucherSectionTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (state.failed)
                Text(
                  l10n.voucherFailed,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.palette.warnInk,
                  ),
                )
              else
                for (final offer in state.offers) ...[
                  VoucherOfferCard(
                    offer: offer,
                    claimed: state.claimed.contains(offer.id),
                    claiming: state.claiming == offer.id,
                    onClaim: () => _claim(context, offer),
                  ),
                  const SizedBox(height: 10),
                ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _claim(BuildContext context, Voucher offer) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<ShopVouchersCubit>();
    try {
      await cubit.claim(offer);
    } catch (error) {
      if (!context.mounted) return;
      // 409 is the shop's answer, not a network fault: someone took the last
      // one, or the shop stopped the offer while this screen was open. Saying
      // "could not claim" for that would blame the wrong thing.
      final gone = error is ApiException && error.statusCode == 409;
      AppFeedback.showSnackBar(
        context,
        gone ? l10n.voucherGoneNow : l10n.voucherClaimFailed,
        icon: Icons.error_outline,
      );
      return;
    }
    if (!context.mounted) return;
    AppFeedback.showSnackBar(context, l10n.voucherClaimedOk);
  }
}
