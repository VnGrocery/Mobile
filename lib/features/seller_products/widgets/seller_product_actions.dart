import 'package:flutter/material.dart';

import 'package:vngrocery/core/ui/app_sheet.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'package:vngrocery/features/home/category_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerProductActionSheet extends StatelessWidget {
  final Product product;
  final VoidCallback onOpenDetail;
  final VoidCallback onOpenHistory;
  final VoidCallback onCreatePledge;
  final VoidCallback onEdit;

  /// Moves the listing between draft, on sale and hidden. The sheet offers
  /// only the move that makes sense from where the product stands.
  final ValueChanged<String> onChangeStatus;
  final VoidCallback onDelete;

  const SellerProductActionSheet({
    super.key,
    required this.product,
    required this.onOpenDetail,
    required this.onOpenHistory,
    required this.onCreatePledge,
    required this.onEdit,
    required this.onChangeStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: AppSheetHandle()),
          const SizedBox(height: 18),
          Text(
            product.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${CategoryPresenter.label(AppLocalizations.of(context), product.category)} - ${SellerProductPresenter.stateLabel(product.status, AppLocalizations.of(context))}',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          SellerProductActionRow(
            icon: Icons.visibility,
            label: AppLocalizations.of(context).sellerProductActionViewDetail,
            onTap: onOpenDetail,
          ),
          SellerProductActionRow(
            icon: Icons.history,
            label: AppLocalizations.of(context).sellerProductActionViewHistory,
            onTap: onOpenHistory,
          ),
          SellerProductActionRow(
            icon: Icons.verified_user,
            label: AppLocalizations.of(context).sellerProductActionAddPledge,
            onTap: onCreatePledge,
          ),
          SellerProductActionRow(
            icon: Icons.edit_outlined,
            label: AppLocalizations.of(context).sellerProductActionEdit,
            onTap: onEdit,
          ),
          // The status badge on the card said "Đã ẩn" while nothing in the app
          // could hide anything, and the Đang bán / Bản nháp filters could
          // never be exercised. These are the moves that fill that in.
          if (SellerProductPresenter.publishAction(product.status)
              case final next?)
            SellerProductActionRow(
              icon: next == SellerProductPresenter.publishedState
                  ? Icons.storefront_outlined
                  : Icons.visibility_off_outlined,
              label: SellerProductPresenter.publishActionLabel(
                product.status,
                AppLocalizations.of(context),
              ),
              onTap: () => onChangeStatus(next),
            ),
          SellerProductActionRow(
            icon: Icons.delete_outline,
            label: AppLocalizations.of(context).sellerProductActionDelete,
            danger: true,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class SellerProductActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Marks the one row that removes something. Orange, not red: red is the
  /// price colour in this app and nothing else.
  final bool danger;

  const SellerProductActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: danger ? palette.warningBg : palette.positiveBg,
        child: Icon(
          icon,
          color: danger ? palette.warnInk : AppColors.primaryGreen,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: danger ? palette.warnInk : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
