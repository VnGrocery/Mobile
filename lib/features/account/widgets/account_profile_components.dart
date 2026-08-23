import 'package:flutter/material.dart';

import 'package:vngrocery/core/widgets/user_avatar.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class AccountProfileSummary extends StatelessWidget {
  final String displayName;
  final String email;
  final bool isSeller;
  final ValueChanged<String> onRoleChanged;

  const AccountProfileSummary({
    super.key,
    required this.displayName,
    required this.email,
    required this.isSeller,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          UserAvatar(name: displayName, radius: 50),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            email,
            style: TextStyle(fontSize: 14, color: context.palette.textSecondary),
          ),
          const SizedBox(height: 16),
          AccountRoleSwitch(
            isSeller: isSeller,
            onRoleChanged: onRoleChanged,
          ),
        ],
      ),
    );
  }
}

class AccountRoleSwitch extends StatelessWidget {
  final bool isSeller;
  final ValueChanged<String> onRoleChanged;

  const AccountRoleSwitch({
    super.key,
    required this.isSeller,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          AccountRoleItem(
            label: l10n.commonBuyer,
            icon: Icons.person,
            selected: !isSeller,
            onTap: () => onRoleChanged('user'),
          ),
          AccountRoleItem(
            label: l10n.commonSeller,
            icon: Icons.storefront,
            selected: isSeller,
            onTap: () => onRoleChanged('seller'),
          ),
        ],
      ),
    );
  }
}

class AccountRoleItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const AccountRoleItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? AppColors.primaryGreen : AppColors.gray,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.primaryGreen : AppColors.gray,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountModeCard extends StatelessWidget {
  final bool isSeller;

  const AccountModeCard({super.key, required this.isSeller});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSeller ? Icons.storefront : Icons.person,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isSeller
                    ? l10n.accountSellerModeBody
                    : l10n.accountBuyerModeBody,
                style: const TextStyle(height: 1.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
