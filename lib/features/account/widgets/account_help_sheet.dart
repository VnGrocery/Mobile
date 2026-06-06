import 'package:flutter/material.dart';

import 'package:vngrocery/core/ui/app_sheet.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class AccountHelpSheet extends StatelessWidget {
  const AccountHelpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: AppSheetHandle()),
          const SizedBox(height: 18),
          Text(
            l10n.accountHelpTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          AccountHelpRow(
            icon: Icons.qr_code_scanner,
            title: l10n.accountHelpScanTitle,
            body: l10n.accountHelpScanBody,
          ),
          AccountHelpRow(
            icon: Icons.storefront,
            title: l10n.accountHelpStoreTitle,
            body: l10n.accountHelpStoreBody,
          ),
          AccountHelpRow(
            icon: Icons.mail,
            title: l10n.accountHelpContactTitle,
            body: l10n.accountHelpContactBody,
          ),
        ],
      ),
    );
  }
}

class AccountHelpRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const AccountHelpRow({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: context.palette.positiveBg,
            child: Icon(icon, size: 18, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
