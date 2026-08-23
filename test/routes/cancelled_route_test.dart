import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/account/controllers/session_state.dart';
import 'package:vngrocery/features/cart/controllers/cart_bloc.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/screens/auth_screen.dart';

/// A host that wires what the real app wires, so the routes under test build
/// the same way they do in the app.
Widget _app() {
  final session = SessionState.fromManager(SessionManager.instance);
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => SessionCubit()),
      BlocProvider(create: (_) => CartBloc()),
    ],
    child: MaterialApp(
      locale: const Locale('vi'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: Routes.routeFactory(session),
      initialRoute: Routes.auth,
    ),
  );
}

void main() {
  tearDown(SessionManager.instance.logout);

  testWidgets('a cancelled navigation that clears the history still shows a page', (
    tester,
  ) async {
    // The seller-only route is refused for a signed-in buyer, so the factory
    // answers with the cancelled-navigation route. Asking for it with
    // pushNamedAndRemoveUntil is the shape that used to strand the app: the
    // routes underneath are removed after the new one is pushed, the cancelled
    // route popped itself anyway, and the navigator was left holding nothing -
    // a blank page with no way back, killable only from the task switcher.
    SessionManager.instance.login(email: 'buyer@example.com');
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamedAndRemoveUntil(Routes.sellerProducts, (_) => false);
    await tester.pumpAndSettle();

    // Something readable is on screen, and the navigator is not empty.
    expect(find.byType(Scaffold), findsWidgets);
    expect(find.byType(SizedBox), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a cancelled navigation over a live page just goes back', (
    tester,
  ) async {
    SessionManager.instance.login(email: 'buyer@example.com');
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(Routes.sellerProducts);
    await tester.pumpAndSettle();

    // The reader is returned to where they were, not pushed somewhere new.
    expect(find.byType(AuthScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
