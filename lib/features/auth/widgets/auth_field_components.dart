import 'package:flutter/material.dart';

import 'package:vngrocery/core/validation/app_validators.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}

class AuthPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool visible;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.visible,
    required this.onToggle,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: onToggle,
          tooltip: visible
              ? AppLocalizations.of(context).a11yHidePassword
              : AppLocalizations.of(context).a11yShowPassword,
          icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
  }
}

class RegisterNameField extends StatelessWidget {
  final bool visible;
  final TextEditingController controller;

  const RegisterNameField({
    super.key,
    required this.visible,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: visible
          ? Column(
              key: const ValueKey('register-name'),
              children: [
                AuthTextField(
                  controller: controller,
                  label: AppLocalizations.of(context).authDisplayNameLabel,
                  icon: Icons.person,
                  validator: (value) => AppValidators.displayName(
                    value,
                    AppLocalizations.of(context),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            )
          : const SizedBox.shrink(key: ValueKey('login-name')),
    );
  }
}

class PasswordRules extends StatelessWidget {
  final String password;

  const PasswordRules({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final strength = AppValidators.passwordStrength(password);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context).authPasswordStrength,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                strength >= 4
                    ? AppLocalizations.of(context).authPasswordStrong
                    : (strength >= 2
                          ? AppLocalizations.of(context).authPasswordMedium
                          : AppLocalizations.of(context).authPasswordWeak),
                style: TextStyle(
                  color: _strengthColor(strength),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: strength / 4,
              color: _strengthColor(strength),
              backgroundColor: scheme.surface,
            ),
          ),
        ],
      ),
    );
  }

  Color _strengthColor(int strength) {
    return switch (strength) {
      0 || 1 => AppColors.priceRed,
      2 || 3 => AppColors.warningOrange,
      _ => AppColors.primaryGreen,
    };
  }
}
