import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

import 'package:vngrocery/theme/app_colors.dart';

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
    return Material(
      color: AppColors.primaryGreen,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: canCreatePledge ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.add_a_photo, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      l10n.sellerAddRecordTitle,
                      style: TextStyle(
                        color: Colors.white,
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
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_forward, color: AppColors.primaryGreen),
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
  final VoidCallback onOpenHistory;

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
