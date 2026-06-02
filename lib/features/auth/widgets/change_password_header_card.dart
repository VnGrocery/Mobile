import 'package:flutter/material.dart';

import '../../../core/validation/app_validators.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';
import 'change_password_strength.dart';

class ChangePasswordHeaderCard extends StatelessWidget {
  final String password;

  const ChangePasswordHeaderCard({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strength = AppValidators.passwordStrength(password);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: palette.elevatedCard,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.verified_user, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bảo mật tài khoản',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 4),
                Text(
                  passwordStrengthLabel(strength),
                  style: TextStyle(
                    color: passwordStrengthColor(strength),
                    fontWeight: FontWeight.w600,
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
