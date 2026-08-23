import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

import 'seller_shop_text_field.dart';

class SellerShopFields extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController description;
  final TextEditingController address;

  /// Why the shop is being changed. Null while creating one: there is no
  /// previous state to explain.
  final TextEditingController? changeReason;
  final ValueChanged<String> onChanged;

  /// Whether new product comments wait for the owner. Null while creating a
  /// shop: there are no comments to screen yet.
  final bool? commentModeration;
  final ValueChanged<bool>? onCommentModerationChanged;

  const SellerShopFields({
    super.key,
    required this.name,
    required this.description,
    required this.address,
    required this.onChanged,
    this.changeReason,
    this.commentModeration,
    this.onCommentModerationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        SellerShopTextField(
          controller: name,
          label: l10n.sellerShopNameLabel,
          icon: Icons.storefront,
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
        SellerShopTextField(
          controller: description,
          label: l10n.sellerShopDescriptionLabel,
          icon: Icons.notes,
          maxLines: 4,
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
        SellerShopTextField(
          controller: address,
          label: l10n.sellerShopAddressLabel,
          icon: Icons.location_on,
          onChanged: onChanged,
        ),
        if (commentModeration != null) ...[
          const SizedBox(height: 12),
          _CommentModerationSwitch(
            value: commentModeration!,
            onChanged: onCommentModerationChanged ?? (_) {},
          ),
        ],
        if (changeReason != null) ...[
          const SizedBox(height: 12),
          SellerShopTextField(
            controller: changeReason!,
            label: l10n.changeReasonLabel,
            icon: Icons.edit_note,
            onChanged: onChanged,
          ),
          const SizedBox(height: 6),
          // Says what the reason is for, so it does not read as one more box
          // to fill in.
          Text(
            l10n.changeReasonExplainer,
            style: TextStyle(
              fontSize: 12,
              color: context.palette.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }
}

/// The comment-screening switch, with the price of turning it on stated where
/// the seller decides rather than buried in a help page.
class _CommentModerationSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CommentModerationSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.mutedSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.sellerCommentsModerationLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(value: value, onChanged: onChanged),
            ],
          ),
          Text(
            l10n.sellerCommentsModerationExplainer,
            style: TextStyle(
              fontSize: 12,
              color: palette.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
