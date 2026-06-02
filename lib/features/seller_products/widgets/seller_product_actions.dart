import 'package:flutter/material.dart';

import '../../../core/ui/app_sheet.dart';
import '../../../data/models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';
import '../seller_product_presenter.dart';

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
            '${product.category} - ${SellerProductPresenter.stateLabel(product.status)}',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          SellerProductActionRow(
            icon: Icons.visibility,
            label: 'Xem chi tiết',
            onTap: onOpenDetail,
          ),
          SellerProductActionRow(
            icon: Icons.history,
            label: 'Xem lịch sử ghi nhận',
            onTap: onOpenHistory,
          ),
          SellerProductActionRow(
            icon: Icons.verified_user,
            label: 'Thêm ghi nhận mới',
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
