import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/account/controllers/session_state.dart';
import 'package:vngrocery/routes/app_routes.dart';

/// A logged-in buyer.
const _buyer = SessionState(
  token: 'test-token',
  shopId: null,
  email: 'buyer@vngrocery.demo',
  displayName: 'Khách Demo',
  role: 'buyer',
);

Route<dynamic> _routeFor(String name, {Object? arguments}) =>
    Routes.onGenerateRoute(
      RouteSettings(name: name, arguments: arguments),
      session: _buyer,
    );

void main() {
  group('a navigation that cannot be satisfied', () {
    test('is not answered with the home screen', () {
      // Answering with home pushed a second MainScreen on top of wherever the
      // reader was, so Back surfaced a home screen from the middle of the
      // history instead of going back.
      final route = _routeFor(Routes.productDetail);

      expect(
        route.settings.name,
        isNot(Routes.main),
        reason: 'a cancelled navigation must not masquerade as the home route',
      );
    });

    test('keeps the name that was actually requested', () {
      expect(
        _routeFor(Routes.productDetail).settings.name,
        Routes.productDetail,
      );
    });

    test('does not paint over the page the reader is still on', () {
      // Opaque would blank the screen for the frame before it pops itself.
      final route = _routeFor(Routes.productDetail) as PageRoute;

      expect(route.opaque, isFalse);
      expect(route.transitionDuration, Duration.zero);
    });

    test('applies to a route this session may not open', () {
      // A buyer opening a seller-only route has nowhere better to be sent, so
      // the navigation is cancelled rather than answered with home.
      expect(
        _routeFor(Routes.sellerProducts).settings.name,
        isNot(Routes.main),
      );
      expect(_routeFor(Routes.qrLabel).settings.name, isNot(Routes.main));
    });

    test('applies to every route that needs arguments', () {
      // Each of these returns the fallback when its arguments are missing; a
      // new one added without this guard would stack a home screen again.
      const needArguments = [
        Routes.productDetail,
        Routes.storeDetail,
        Routes.review,
        Routes.qrLabel,
        Routes.voucherQr,
        Routes.blockchainProof,
      ];

      for (final name in needArguments) {
        expect(
          _routeFor(name).settings.name,
          isNot(Routes.main),
          reason: '$name still answers with the home screen',
        );
      }
    });
  });

  group('signing in is still a gate, not a cancellation', () {
    const signedOut = SessionState(
      token: null,
      shopId: null,
      email: '',
      displayName: '',
      role: 'buyer',
    );

    test('a protected route sends a signed-out reader to sign in', () {
      // This redirect is worth making: they can sign in and carry on.
      final route = Routes.onGenerateRoute(
        const RouteSettings(name: Routes.cart),
        session: signedOut,
      );

      expect(route.settings.name, Routes.auth);
    });

    test('the sign-in screen itself does not redirect to itself', () {
      final route = Routes.onGenerateRoute(
        const RouteSettings(name: Routes.auth),
        session: signedOut,
      );

      expect(route.settings.name, Routes.auth);
    });
  });

  group('a navigation that can be satisfied', () {
    test('still builds the page it was asked for', () {
      final route = _routeFor(Routes.cart);

      expect(route.settings.name, Routes.cart);
      expect(route, isA<MaterialPageRoute<dynamic>>());
    });

    test('home itself is unaffected', () {
      expect(_routeFor(Routes.main).settings.name, Routes.main);
    });
  });
}
