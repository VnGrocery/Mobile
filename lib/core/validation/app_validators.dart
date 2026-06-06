import 'package:vngrocery/l10n/app_localizations.dart';

class AppValidators {
  const AppValidators._();

  static String? email(String? value, AppLocalizations l10n) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return l10n.validationEmailRequired;
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!ok) return l10n.validationEmailInvalid;
    return null;
  }

  static String? displayName(String? value, AppLocalizations l10n) {
    final name = (value ?? '').trim();
    if (name.length < 2) {
      return l10n.validationDisplayNameTooShort;
    }
    return null;
  }

  static String? password(
    String? value, {
    required bool register,
    required AppLocalizations l10n,
  }) {
    if ((value ?? '').length < (register ? 8 : 1)) {
      return register
          ? l10n.validationPasswordTooShort
          : l10n.validationPasswordRequired;
    }
    return null;
  }

  static String? newPassword(String? value, AppLocalizations l10n) {
    if ((value ?? '').length < 8) {
      return l10n.validationNewPasswordTooShort;
    }
    return null;
  }

  static String? currentPassword(String? value, AppLocalizations l10n) {
    if ((value ?? '').isEmpty) {
      return l10n.validationCurrentPasswordRequired;
    }
    return null;
  }

  static String? passwordChange({
    required String currentPassword,
    required String newPassword,
    required AppLocalizations l10n,
  }) {
    if (newPassword == currentPassword) {
      return l10n.validationPasswordMustDiffer;
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    String password,
    AppLocalizations l10n,
  ) {
    if ((value ?? '') != password) {
      return l10n.validationConfirmPasswordMismatch;
    }
    return null;
  }

  static int passwordStrength(String password) {
    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    return score.clamp(0, 4);
  }
}
