import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class AccountSectionLabel extends StatelessWidget {
  final String title;

  const AccountSectionLabel(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AccountMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: scheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(label, style: const TextStyle(fontSize: 15)),
                ),
                Icon(Icons.chevron_right, color: palette.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountSwitchItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AccountSwitchItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: scheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 15)),
              ),
              Switch(
                value: value,
                activeThumbColor: AppColors.primaryGreen,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountLogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? selectorKey;

  const AccountLogoutButton({
    super.key,
    required this.onTap,
    this.selectorKey,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: selectorKey == null ? null : ValueKey(selectorKey!),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).accountLogoutTitle,
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
