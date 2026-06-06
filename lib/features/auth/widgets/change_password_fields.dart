import 'package:flutter/material.dart';

import 'package:vngrocery/core/validation/app_validators.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'auth_components.dart';

class ChangePasswordFields extends StatelessWidget {
  final TextEditingController currentPassword;
  final TextEditingController newPassword;
  final TextEditingController confirmPassword;
  final bool showCurrent;
  final bool showNew;
  final bool showConfirm;
  final VoidCallback onToggleCurrent;
  final VoidCallback onToggleNew;
  final VoidCallback onToggleConfirm;
  final ValueChanged<String> onPasswordChanged;

  const ChangePasswordFields({
    super.key,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.showCurrent,
    required this.showNew,
    required this.showConfirm,
    required this.onToggleCurrent,
    required this.onToggleNew,
    required this.onToggleConfirm,
    required this.onPasswordChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        AuthPasswordField(
          controller: currentPassword,
          label: l10n.validationCurrentPasswordLabel,
          visible: showCurrent,
          onToggle: onToggleCurrent,
          validator: (value) => AppValidators.currentPassword(value, l10n),
        ),
        const SizedBox(height: 12),
        AuthPasswordField(
          controller: newPassword,
          label: l10n.authNewPasswordLabel,
          visible: showNew,
          onToggle: onToggleNew,
          onChanged: onPasswordChanged,
          validator: (value) {
            final error = AppValidators.newPassword(value, l10n);
            if (error != null) return error;
            return AppValidators.passwordChange(
              currentPassword: currentPassword.text,
              newPassword: value ?? '',
              l10n: l10n,
            );
          },
        ),
        const SizedBox(height: 12),
        AuthPasswordField(
          controller: confirmPassword,
          label: l10n.authConfirmNewPasswordLabel,
          visible: showConfirm,
          onToggle: onToggleConfirm,
          validator: (value) => AppValidators.confirmPassword(
            value,
            newPassword.text,
            l10n,
          ),
        ),
      ],
    );
  }
}
