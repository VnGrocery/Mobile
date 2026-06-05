import 'package:flutter/material.dart';

import 'package:vngrocery/core/validation/app_validators.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'change_password_strength.dart';

class ChangePasswordRuleCard extends StatelessWidget {
  final String password;

  const ChangePasswordRuleCard({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strength = AppValidators.passwordStrength(password);
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.authPasswordRuleTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: strength / 4,
              color: passwordStrengthColor(strength),
              backgroundColor: palette.elevatedCard,
            ),
          ),
          const SizedBox(height: 12),
          PasswordRuleRow(text: l10n.authPasswordRuleMinLength),
          PasswordRuleRow(text: l10n.authPasswordRuleComplexity),
          PasswordRuleRow(text: l10n.authPasswordRuleDifferentFromCurrent),
        ],
      ),
    );
  }
}

class PasswordRuleRow extends StatelessWidget {
  final String text;

  const PasswordRuleRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
