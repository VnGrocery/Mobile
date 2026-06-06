import 'package:flutter/material.dart';

import 'package:vngrocery/core/ui/app_sheet.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerProductActionSheet extends StatelessWidget {
  final Product product;
  final VoidCallback onOpenDetail;
  final VoidCallback onOpenHistory;
  final VoidCallback onCreatePledge;

  const SellerProductActionSheet({
    super.key,
    required this.product,
    required this.onOpenDetail,
    required this.onOpenHistory,
    required this.onCreatePledge,
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
            '${SellerProductPresenter.categoryLabel(product.category, AppLocalizations.of(context))} - ${SellerProductPresenter.stateLabel(product.status, AppLocalizations.of(context))}',
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
        ],
      ),
    );
  }
}

class SellerProductActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SellerProductActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: context.palette.positiveBg,
        child: Icon(icon, color: AppColors.primaryGreen),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
