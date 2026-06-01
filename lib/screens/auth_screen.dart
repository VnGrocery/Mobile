import 'package:flutter/material.dart';

import '../data/session.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _tab = 0; // 0 = đăng nhập, 1 = đăng ký
  bool _loading = false;

  final _email = TextEditingController(text: 'demo@vnmeat.com');
  final _password = TextEditingController(text: '123456');
  final _name = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    SessionManager.instance.login(email: _email.text);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, Routes.main, (r) => false);
  }

  void _forgotPassword() {
    showDialog(context: context, builder: (_) => const _ForgotPasswordDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 64),
              const Center(
                child: Text('VNMeat',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: AppColors.meatRed)),
              ),
              Center(
                child: Text(
                  _tab == 0
                      ? 'Chào mừng bạn quay lại'
                      : 'Tham gia cộng đồng minh bạch',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 48),
              _segmented(),
              const SizedBox(height: 32),
              if (_tab == 1) ...[
                _field(_name, 'Tên hiển thị', Icons.person),
                const SizedBox(height: 16),
              ],
              _field(_email, 'Email', Icons.email),
              const SizedBox(height: 16),
              _field(_password, 'Mật khẩu', Icons.lock, obscure: true),
              if (_tab == 0)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: const Text('Quên mật khẩu?',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : Text(_tab == 0 ? 'Đăng nhập' : 'Tạo tài khoản',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: _loading ? null : () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Color(0xFFD3D3D3)),
                  ),
                  child: const Text('Tiếp tục với Google'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _segmented() {
    return Container(
      height: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(27),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: _tab == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(23),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              _segItem('Đăng nhập', 0),
              _segItem('Đăng ký', 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _segItem(String label, int idx) {
    final active = _tab == idx;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(23),
        onTap: () => setState(() => _tab = idx),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? AppColors.meatRed : Colors.grey,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon,
      {bool obscure = false}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog();

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  int _step = 0;
  final _email = TextEditingController();
  final _newPass = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _newPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_step == 0 ? 'Quên mật khẩu' : 'Đặt lại mật khẩu'),
      content: _step == 0
          ? TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            )
          : TextField(
              controller: _newPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
        TextButton(
          onPressed: () {
            if (_step == 0) {
              setState(() => _step = 1);
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã đổi mật khẩu (giả lập)')),
              );
            }
          },
          child: Text(_step == 0 ? 'Tiếp tục' : 'Đổi mật khẩu'),
        ),
      ],
    );
  }
}
