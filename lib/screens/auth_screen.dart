import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'package:vngrocery/core/validation/app_validators.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/auth/widgets/auth_components.dart';
import 'package:vngrocery/features/auth/widgets/forgot_password_sheet.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 44),
              const AuthBrandHeader(),
              const SizedBox(height: 8),
              AuthSubtitle(register: _isRegister),
              const SizedBox(height: 36),
              AuthSegmentedControl(value: _tab, onChanged: _switchTab),
              const SizedBox(height: 24),
              AuthInfoCard(register: _isRegister),
              const SizedBox(height: 18),
              RegisterNameField(
                visible: _isRegister,
                controller: _name,
              ),
              AuthTextField(
                controller: _email,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: AppValidators.email,
              ),
              const SizedBox(height: 14),
              AuthPasswordField(
                controller: _password,
                label: 'Mật khẩu',
                visible: _showPassword,
                onToggle: () => setState(() => _showPassword = !_showPassword),
                onChanged: (_) => setState(() {}),
                validator: (value) => AppValidators.password(
                  value,
                  register: _isRegister,
                ),
              ),
              if (_isRegister) ...[
                const SizedBox(height: 14),
                AuthPasswordField(
                  controller: _confirmPassword,
                  label: 'Nhập lại mật khẩu',
                  visible: _showConfirmPassword,
                  onToggle: () => setState(
                    () => _showConfirmPassword = !_showConfirmPassword,
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (value) => AppValidators.confirmPassword(
                    value,
                    _password.text,
                  ),
                ),
                const SizedBox(height: 14),
                PasswordRules(password: _password.text),
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
              AuthSubmitButton(
                loading: _loading,
                register: _isRegister,
                onPressed: _submit,
              ),
              const SizedBox(height: 16),
              GoogleSignInButton(
                loading: _loading,
                onPressed: _continueWithGoogle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    await AppDelayService.instance.wait(AppDelayKind.authLogin);
    if (!mounted) return;
    context.read<SessionCubit>().login(
          email: _email.text,
          displayName: _isRegister ? _name.text : null,
        );
    Navigator.pushNamedAndRemoveUntil(context, Routes.main, (r) => false);
  }

  Future<void> _continueWithGoogle() async {
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    await AppDelayService.instance.wait(AppDelayKind.authRegister);
    if (!mounted) return;
    context.read<SessionCubit>().login(
          email: 'google.demo@vngrocery.com',
          displayName: 'Google Demo',
        );
    Navigator.pushNamedAndRemoveUntil(context, Routes.main, (r) => false);
  }

  void _forgotPassword() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.appBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ForgotPasswordSheet(),
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
}
