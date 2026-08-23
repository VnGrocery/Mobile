import 'package:vngrocery/core/network/api_exception.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

/// Turns whatever went wrong into something a person can act on.
///
/// The auth screen used to print error.toString(), so a Vietnamese reader was
/// shown the server's raw English - "invalid credentials" - and a dropped
/// connection produced a ClientException with a stack of host details in it.
class AuthErrorPresenter {
  const AuthErrorPresenter._();

  static String message(Object error, AppLocalizations l10n) {
    if (error is! ApiException) return l10n.authErrorNetwork;
    switch (error.statusCode) {
      case 401:
        return l10n.authErrorInvalidCredentials;
      case 403:
        return l10n.authErrorAccountDeleted;
      case 400:
        // Registering with an address somebody already used is the one 400
        // worth naming; the rest are the email and password rules.
        return error.message.contains('already registered')
            ? l10n.authErrorEmailTaken
            : l10n.authErrorInvalidInput;
      default:
        return l10n.authErrorGeneric;
    }
  }
}
