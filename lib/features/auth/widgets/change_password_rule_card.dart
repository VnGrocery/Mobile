import 'package:flutter/material.dart';

import 'package:vngrocery/core/validation/app_validators.dart';
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yêu cầu mật khẩu',
            style: TextStyle(fontWeight: FontWeight.bold),
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
          const PasswordRuleRow(text: 'Tối thiểu 8 ký tự'),
          const PasswordRuleRow(
            text: 'Nên có chữ hoa, số và ký tự đặc biệt',
          ),
          const PasswordRuleRow(
            text: 'Không dùng lại mật khẩu hiện tại',
          ),
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
