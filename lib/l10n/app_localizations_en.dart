// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'VnGrocery';

  @override
  String get authLoginTab => 'Sign in';

  @override
  String get authRegisterTab => 'Create account';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authRegisterSubtitle => 'Create an account to save product checks';

  @override
  String get authLoginInfo =>
      'Sign in to check products, view maps, and compare store prices.';

  @override
  String get authRegisterInfo =>
      'Demo accounts use sample data until a real API is connected.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authDisplayNameLabel => 'Display name';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authPasswordStrength => 'Password strength';

  @override
  String get authPasswordStrong => 'Strong';

  @override
  String get authPasswordMedium => 'Medium';

  @override
  String get authPasswordWeak => 'Weak';

  @override
  String get authForgotPasswordTitle => 'Forgot password';

  @override
  String get authResetPasswordTitle => 'Reset password';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your account email for demo verification.';

  @override
  String get authResetPasswordSubtitle =>
      'Create a new password to continue signing in.';

  @override
  String get authNewPasswordLabel => 'New password';

  @override
  String get authConfirmNewPasswordLabel => 'Confirm new password';

  @override
  String get authContinue => 'Continue';

  @override
  String get authChangePassword => 'Change password';

  @override
  String get authPasswordResetDemo => 'Demo password reset complete';
}
