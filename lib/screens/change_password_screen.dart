import 'package:flutter/material.dart';

import '../core/ui/app_feedback.dart';
import '../features/auth/widgets/change_password_components.dart';
import '../theme/app_palette.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _saving = false;

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ChangePasswordHeaderCard(password: _newPassword.text),
              const SizedBox(height: 18),
              ChangePasswordFields(
                currentPassword: _currentPassword,
                newPassword: _newPassword,
                confirmPassword: _confirmPassword,
                showCurrent: _showCurrent,
                showNew: _showNew,
                showConfirm: _showConfirm,
                onToggleCurrent: () =>
                    setState(() => _showCurrent = !_showCurrent),
                onToggleNew: () => setState(() => _showNew = !_showNew),
                onToggleConfirm: () =>
                    setState(() => _showConfirm = !_showConfirm),
                onPasswordChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 18),
              ChangePasswordRuleCard(password: _newPassword.text),
              const SizedBox(height: 24),
              ChangePasswordSubmitButton(saving: _saving, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() => _saving = false);
    AppFeedback.showSnackBar(context, 'Đã đổi mật khẩu demo thành công');
    Navigator.pop(context);
  }
}
