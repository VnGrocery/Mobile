import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/network/api_exception.dart';
import 'package:vngrocery/features/auth/auth_error_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

void main() {
  testWidgets('AuthErrorPresenter speaks the reader\'s language', (
    tester,
  ) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    // The screen used to print the server's own English straight into a
    // snackbar: "invalid credentials".
    expect(
      AuthErrorPresenter.message(
        const ApiException(401, 'invalid credentials'),
        l10n,
      ),
      l10n.authErrorInvalidCredentials,
    );
    expect(
      AuthErrorPresenter.message(
        const ApiException(403, 'account is deleted'),
        l10n,
      ),
      l10n.authErrorAccountDeleted,
    );
    expect(
      AuthErrorPresenter.message(
        const ApiException(400, 'email is already registered'),
        l10n,
      ),
      l10n.authErrorEmailTaken,
    );
    expect(
      AuthErrorPresenter.message(
        const ApiException(400, 'invalid credentials: password must be at '
            'least 8 characters'),
        l10n,
      ),
      l10n.authErrorInvalidInput,
    );
    expect(
      AuthErrorPresenter.message(const ApiException(500, 'boom'), l10n),
      l10n.authErrorGeneric,
    );
    // Anything that never reached the server at all.
    expect(
      AuthErrorPresenter.message(Exception('offline'), l10n),
      l10n.authErrorNetwork,
    );
  });
}
