import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class CreateSellerPledgeCard extends StatelessWidget {
  final bool canCreatePledge;
  final VoidCallback onTap;

  const CreateSellerPledgeCard({
    super.key,
    required this.canCreatePledge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    // Khi chưa có sản phẩm thì thẻ này không bấm được. Trước đây nó vẫn xanh
    // đặc y như lúc bấm được, nên người bán bấm vào và không có gì xảy ra -
    // với người không quen khái niệm "nút bị khoá" thì đó là "app hỏng".
    final background = canCreatePledge
        ? AppColors.primaryGreen
        : palette.mutedSurface;
    final foreground = canCreatePledge
        ? Colors.white
        : palette.textSecondary;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: canCreatePledge ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.add_a_photo, color: foreground),
                    const SizedBox(height: 12),
                    Text(
                      l10n.sellerAddRecordTitle,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      canCreatePledge
                          ? l10n.sellerAddRecordBody
                          : l10n.sellerNeedProductFirst,
                      style: TextStyle(
                        color: canCreatePledge
                            ? Colors.white.withValues(alpha: 0.85)
                            : foreground,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: canCreatePledge
                    ? Colors.white
                    : palette.appBackground,
                child: Icon(
                  canCreatePledge ? Icons.arrow_forward : Icons.lock_outline,
                  color: canCreatePledge
                      ? AppColors.primaryGreen
                      : palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SellerDashboardActions extends StatelessWidget {
  final VoidCallback onOpenProducts;

  /// Null khi cửa hàng chưa có sản phẩm nào để xem lịch sử. Trước đây nút vẫn
  /// bấm được và handler lặng lẽ `return`, nên nó chết câm.
  final VoidCallback? onOpenHistory;

  const SellerDashboardActions({
    super.key,
    required this.onOpenProducts,
    required this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onOpenProducts,
            icon: const Icon(Icons.inventory_2),
            label: Text(l10n.sellerProductsLabel),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onOpenHistory,
            icon: const Icon(Icons.history),
            label: Text(l10n.sellerHistoryLabel),
          ),
        ),
      ],
    );
  }
}
