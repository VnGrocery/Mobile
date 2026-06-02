import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
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

  int get _strength {
    final value = _newPassword.text;
    var score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(value)) score++;
    if (RegExp(r'[0-9]').hasMatch(value)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) score++;
    return score;
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đổi mật khẩu demo thành công')),
    );
    Navigator.pop(context);
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
              _HeaderCard(strength: _strength),
              const SizedBox(height: 18),
              _passwordField(
                controller: _currentPassword,
                label: 'Mật khẩu hiện tại',
                visible: _showCurrent,
                onToggle: () => setState(() => _showCurrent = !_showCurrent),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Nhập mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _passwordField(
                controller: _newPassword,
                label: 'Mật khẩu mới',
                visible: _showNew,
                onChanged: (_) => setState(() {}),
                onToggle: () => setState(() => _showNew = !_showNew),
                validator: (value) {
                  final password = value ?? '';
                  if (password.length < 8) {
                    return 'Mật khẩu mới tối thiểu 8 ký tự';
                  }
                  if (password == _currentPassword.text) {
                    return 'Mật khẩu mới phải khác mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _passwordField(
                controller: _confirmPassword,
                label: 'Nhập lại mật khẩu mới',
                visible: _showConfirm,
                onToggle: () => setState(() => _showConfirm = !_showConfirm),
                validator: (value) {
                  if (value != _newPassword.text) {
                    return 'Mật khẩu nhập lại chưa khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              _RuleCard(strength: _strength),
              const SizedBox(height: 24),
              SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.lock_reset),
                  label:
                      Text(_saving ? 'Đang cập nhật...' : 'Cập nhật mật khẩu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool visible,
    required VoidCallback onToggle,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      onChanged: onChanged,
      validator: validator,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final int strength;

  const _HeaderCard({required this.strength});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
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
                  _strengthLabel(strength),
                  style: TextStyle(
                    color: _strengthColor(strength),
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

class _RuleCard extends StatelessWidget {
  final int strength;

  const _RuleCard({required this.strength});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
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
              color: _strengthColor(strength),
              backgroundColor: palette.elevatedCard,
            ),
          ),
          const SizedBox(height: 12),
          const _RuleRow(text: 'Tối thiểu 8 ký tự'),
          const _RuleRow(text: 'Nên có chữ hoa, số và ký tự đặc biệt'),
          const _RuleRow(text: 'Không dùng lại mật khẩu hiện tại'),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final String text;

  const _RuleRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        children: [
          const Icon(Icons.check_circle,
              size: 16, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

String _strengthLabel(int strength) {
  return switch (strength) {
    0 || 1 => 'Mật khẩu mới còn yếu',
    2 || 3 => 'Mật khẩu mới ở mức khá',
    _ => 'Mật khẩu mới mạnh',
  };
}

Color _strengthColor(int strength) {
  return switch (strength) {
    0 || 1 => AppColors.priceRed,
    2 || 3 => AppColors.warningOrange,
    _ => AppColors.primaryGreen,
  };
}
