import 'package:flutter/material.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/core/ui/app_sheet.dart';
import 'package:vngrocery/core/validation/app_validators.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'auth_components.dart';

class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  int _step = 0;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _email.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _next() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_step == 0) {
      setState(() => _step = 1);
      return;
    }
    Navigator.pop(context);
    AppFeedback.showSnackBar(
      context,
      AppLocalizations.of(context).authPasswordResetDemo,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: AppSheetHandle()),
            const SizedBox(height: 18),
            Text(
              _step == 0
                  ? l10n.authForgotPasswordTitle
                  : l10n.authResetPasswordTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _step == 0
                  ? l10n.authForgotPasswordSubtitle
                  : l10n.authResetPasswordSubtitle,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 18),
            if (_step == 0)
              AuthTextField(
                controller: _email,
                label: l10n.authEmailLabel,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => AppValidators.email(value, l10n),
              )
            else ...[
              AuthPasswordField(
                controller: _newPassword,
                label: l10n.authNewPasswordLabel,
                visible: _showNew,
                onToggle: () => setState(() => _showNew = !_showNew),
                validator: (value) => AppValidators.newPassword(value, l10n),
              ),
              const SizedBox(height: 12),
              AuthPasswordField(
                controller: _confirmPassword,
                label: l10n.authConfirmNewPasswordLabel,
                visible: _showConfirm,
                onToggle: () => setState(() => _showConfirm = !_showConfirm),
                validator: (value) => AppValidators.confirmPassword(
                  value,
                  _newPassword.text,
                  l10n,
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _next,
                child: Text(
                  _step == 0 ? l10n.authContinue : l10n.authChangePassword,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
