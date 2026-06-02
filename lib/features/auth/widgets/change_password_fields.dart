import 'package:flutter/material.dart';

import '../../../core/validation/app_validators.dart';
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
    return Column(
      children: [
        AuthPasswordField(
          controller: currentPassword,
          label: 'Mật khẩu hiện tại',
          visible: showCurrent,
          onToggle: onToggleCurrent,
          validator: AppValidators.currentPassword,
        ),
        const SizedBox(height: 12),
        AuthPasswordField(
          controller: newPassword,
          label: 'Mật khẩu mới',
          visible: showNew,
          onToggle: onToggleNew,
          onChanged: onPasswordChanged,
          validator: (value) => AppValidators.changedPassword(
            value,
            currentPassword.text,
          ),
        ),
        const SizedBox(height: 12),
        AuthPasswordField(
          controller: confirmPassword,
          label: 'Nhập lại mật khẩu mới',
          visible: showConfirm,
          onToggle: onToggleConfirm,
          validator: (value) => AppValidators.confirmPassword(
            value,
            newPassword.text,
          ),
        ),
      ],
    );
  }
}
