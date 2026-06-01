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
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'demo@vngrocery.com');
  final _password = TextEditingController(text: '12345678');
  final _name = TextEditingController();
  final _confirmPassword = TextEditingController();

  int _tab = 0;
  bool _loading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  bool get _isRegister => _tab == 1;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    SessionManager.instance.login(email: _email.text);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, Routes.main, (r) => false);
  }

  void _forgotPassword() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ForgotPasswordSheet(),
    );
  }

  void _switchTab(int nextTab) {
    setState(() {
      _tab = nextTab;
      _showPassword = false;
      _showConfirmPassword = false;
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 44),
              const Center(
                child: Text(
                  'VnGrocery',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppColors.meatRed,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _isRegister
                      ? 'Tạo tài khoản để lưu kiểm chứng sản phẩm'
                      : 'Chào mừng bạn quay lại',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 36),
              _segmented(),
              const SizedBox(height: 24),
              _AuthInfoCard(register: _isRegister),
              const SizedBox(height: 18),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _isRegister
                    ? Column(
                        key: const ValueKey('register-name'),
                        children: [
                          _field(
                            _name,
                            'Tên hiển thị',
                            Icons.person,
                            validator: (value) {
                              if ((value ?? '').trim().length < 2) {
                                return 'Nhập tên hiển thị tối thiểu 2 ký tự';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                        ],
                      )
                    : const SizedBox.shrink(key: ValueKey('login-name')),
              ),
              _field(
                _email,
                'Email',
                Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 14),
              _passwordField(
                controller: _password,
                label: 'Mật khẩu',
                visible: _showPassword,
                onToggle: () => setState(() => _showPassword = !_showPassword),
                validator: (value) {
                  if ((value ?? '').length < (_isRegister ? 8 : 1)) {
                    return _isRegister
                        ? 'Mật khẩu tối thiểu 8 ký tự'
                        : 'Nhập mật khẩu';
                  }
                  return null;
                },
              ),
              if (_isRegister) ...[
                const SizedBox(height: 14),
                _passwordField(
                  controller: _confirmPassword,
                  label: 'Nhập lại mật khẩu',
                  visible: _showConfirmPassword,
                  onToggle: () => setState(
                    () => _showConfirmPassword = !_showConfirmPassword,
                  ),
                  validator: (value) {
                    if (value != _password.text) {
                      return 'Mật khẩu nhập lại chưa khớp';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _PasswordRules(password: _password.text),
              ],
              if (!_isRegister)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _isRegister ? 'Tạo tài khoản' : 'Đăng nhập',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _loading ? null : () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Color(0xFFD3D3D3)),
                  ),
                  icon: const Icon(Icons.g_mobiledata, size: 26),
                  label: const Text('Tiếp tục với Google'),
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

  Widget _segItem(String label, int index) {
    final active = _tab == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(23),
        onTap: () => _switchTab(index),
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

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool visible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      validator: validator,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
  }
}

class _AuthInfoCard extends StatelessWidget {
  final bool register;

  const _AuthInfoCard({required this.register});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              register ? Icons.person_add_alt : Icons.verified_user,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              register
                  ? 'Tài khoản demo sẽ dùng dữ liệu ảo cho đến khi gắn API thật.'
                  : 'Đăng nhập demo để trải nghiệm kiểm chứng, bản đồ và luồng seller.',
              style: const TextStyle(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordRules extends StatelessWidget {
  final String password;

  const _PasswordRules({required this.password});

  int get _strength {
    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Độ mạnh mật khẩu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                _strength >= 4 ? 'Mạnh' : (_strength >= 2 ? 'Khá' : 'Yếu'),
                style: TextStyle(
                  color: _strengthColor(_strength),
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
              value: _strength / 4,
              color: _strengthColor(_strength),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgotPasswordSheet extends StatefulWidget {
  const _ForgotPasswordSheet();

  @override
  State<_ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<_ForgotPasswordSheet> {
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đặt lại mật khẩu demo')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8D8D8),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              _step == 0 ? 'Quên mật khẩu' : 'Đặt lại mật khẩu',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _step == 0
                  ? 'Nhập email tài khoản để xác minh demo.'
                  : 'Tạo mật khẩu mới để tiếp tục đăng nhập.',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 18),
            if (_step == 0)
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              )
            else ...[
              _SheetPasswordField(
                controller: _newPassword,
                label: 'Mật khẩu mới',
                visible: _showNew,
                onToggle: () => setState(() => _showNew = !_showNew),
                validator: (value) {
                  if ((value ?? '').length < 8) {
                    return 'Mật khẩu mới tối thiểu 8 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _SheetPasswordField(
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
            ],
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _next,
                child: Text(_step == 0 ? 'Tiếp tục' : 'Đổi mật khẩu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool visible;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _SheetPasswordField({
    required this.controller,
    required this.label,
    required this.visible,
    required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
  }
}

String? _validateEmail(String? value) {
  final email = (value ?? '').trim();
  if (email.isEmpty) return 'Nhập email';
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
    return 'Email không hợp lệ';
  }
  return null;
}

Color _strengthColor(int strength) {
  return switch (strength) {
    0 || 1 => AppColors.priceRed,
    2 || 3 => AppColors.warningOrange,
    _ => AppColors.primaryGreen,
  };
}
