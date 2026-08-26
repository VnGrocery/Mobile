import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/core/validation/app_validators.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/features/auth/auth_error_presenter.dart';
import 'package:vngrocery/features/auth/widgets/auth_components.dart';
import 'package:vngrocery/features/auth/widgets/forgot_password_sheet.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Whether Google sign-in can be offered at all on this platform.
///
/// google_sign_in's iOS plugin raises an Objective-C exception when no
/// GIDClientID sits in Info.plist, and an ObjC exception aborts the process
/// past any Dart catch: the button is an app crash wearing a Google logo. This
/// build ships no iOS OAuth client, so the honest thing is not to offer it.
/// Add GIDClientID to ios/Runner/Info.plist and this guard can go.
bool get googleSignInAvailable =>
    kIsWeb || defaultTargetPlatform != TargetPlatform.iOS;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  // Deliberately empty: these used to be prefilled with a demo account that
  // does not exist on the server, so the first tap on Sign in always failed
  // with "invalid credentials".
  final _email = TextEditingController();
  final _password = TextEditingController();
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
    final l10n = AppLocalizations.of(context);
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
              RegisterNameField(visible: _isRegister, controller: _name),
              AuthTextField(
                key: const ValueKey('auth.email_field'),
                controller: _email,
                label: AppLocalizations.of(context).authEmailLabel,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => AppValidators.email(value, l10n),
              ),
              const SizedBox(height: 14),
              AuthPasswordField(
                key: const ValueKey('auth.password_field'),
                controller: _password,
                label: AppLocalizations.of(context).authPasswordLabel,
                visible: _showPassword,
                onToggle: () => setState(() => _showPassword = !_showPassword),
                onChanged: (_) => setState(() {}),
                validator: (value) => AppValidators.password(
                  value,
                  register: _isRegister,
                  l10n: l10n,
                ),
              ),
              if (_isRegister) ...[
                const SizedBox(height: 14),
                AuthPasswordField(
                  controller: _confirmPassword,
                  label: AppLocalizations.of(context).authConfirmPasswordLabel,
                  visible: _showConfirmPassword,
                  onToggle: () => setState(
                    () => _showConfirmPassword = !_showConfirmPassword,
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (value) => AppValidators.confirmPassword(
                    value,
                    _password.text,
                    l10n,
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
                    child: Text(
                      AppLocalizations.of(context).authForgotPassword,
                      style: TextStyle(
                        color: context.palette.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              AuthSubmitButton(
                loading: _loading,
                register: _isRegister,
                onPressed: _submit,
              ),
              if (googleSignInAvailable) ...[
                const SizedBox(height: 16),
                GoogleSignInButton(
                  loading: _loading,
                  onPressed: _continueWithGoogle,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      await context.read<SessionCubit>().authenticate(
        email: _email.text,
        password: _password.text,
        register: _isRegister,
        displayName: _name.text,
      );
      if (!mounted) return;
      final shop = await AppRepositories.instance.shops.fetchMine();
      if (!mounted) return;
      if (shop != null) {
        context.read<SessionCubit>().setShopId(shop.id);
      }
      Navigator.pushNamedAndRemoveUntil(context, Routes.main, (r) => false);
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      AppFeedback.showSnackBar(
        context,
        AuthErrorPresenter.message(error, l10n),
        icon: Icons.error_outline,
      );
    }
  }

  Future<void> _continueWithGoogle() async {
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      const clientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
      final account = await GoogleSignIn(
        serverClientId: clientId.isEmpty ? null : clientId,
      ).signIn();
      final token = (await account?.authentication)?.idToken;
      if (token == null || token.isEmpty) {
        // Localised where it is caught; context is not safe after an await.
        throw StateError('google_id_token_missing');
      }
      if (!mounted) return;
      await context.read<SessionCubit>().authenticateGoogle(token);
      final shop = await AppRepositories.instance.shops.fetchMine();
      if (!mounted) return;
      if (shop != null) {
        context.read<SessionCubit>().setShopId(shop.id);
      }
      Navigator.pushNamedAndRemoveUntil(context, Routes.main, (r) => false);
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      AppFeedback.showSnackBar(
        context,
        error is StateError && error.message == 'google_id_token_missing'
            ? l10n.authGoogleTokenError
            : AuthErrorPresenter.message(error, l10n),
        icon: Icons.error_outline,
      );
    }
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
