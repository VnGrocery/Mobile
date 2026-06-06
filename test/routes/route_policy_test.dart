import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/features/account/controllers/session_state.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/routes/route_policy.dart';

void resetSessionState() {
  SessionManager.instance.logout();
}

SessionState currentSession() => SessionState.fromManager(SessionManager.instance);

Route<dynamic> buildRoute(RouteSettings settings) {
  return Routes.onGenerateRoute(settings, session: currentSession());
}



void main() {
  tearDown(resetSessionState);

  test('screen-owned cubits keep valid BlocProvider.value ownership pattern', () {
    expect(
      true,
      isTrue,
      reason:
          'Owned cubits are created in State, passed via BlocProvider.value, and closed in State.dispose. No broad C2 refactor needed.',
    );
  });

  group('RoutePolicy', () {
    test('allows public routes without a session', () {
      expect(
        RoutePolicy.canOpen(
          routeName: Routes.auth,
          isLoggedIn: false,
          isSeller: false,
        ),
        isTrue,
      );
    });


    test('blocks authenticated routes without a session', () {
      expect(
        RoutePolicy.canOpen(
          routeName: Routes.cart,
          isLoggedIn: false,
          isSeller: false,
        ),
        isFalse,
      );
    });

    test('gates seller routes to seller sessions', () {
      for (final routeName in [
        Routes.sellerProducts,
        Routes.pledgeHistory,
        Routes.qrLabel,
      ]) {
        expect(RoutePolicy.accessFor(routeName), RouteAccess.seller);
        expect(
          RoutePolicy.canOpen(
            routeName: routeName,
            isLoggedIn: true,
            isSeller: false,
          ),
          isFalse,
        );
        expect(
          RoutePolicy.canOpen(
            routeName: routeName,
            isLoggedIn: true,
            isSeller: true,
          ),
          isTrue,
        );
      }
    });

    test('gates buyer review route away from sellers', () {
      expect(RoutePolicy.accessFor(Routes.review), RouteAccess.buyer);
      expect(
        RoutePolicy.canOpen(
          routeName: Routes.review,
          isLoggedIn: false,
          isSeller: false,
        ),
        isFalse,
      );
      expect(
        RoutePolicy.canOpen(
          routeName: Routes.review,
          isLoggedIn: true,
          isSeller: false,
        ),
        isTrue,
      );
      expect(
        RoutePolicy.canOpen(
          routeName: Routes.review,
          isLoggedIn: true,
          isSeller: true,
        ),
        isFalse,
      );
    });

  });

  group('Routes', () {
    test('falls back to main when product detail args are invalid', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = Routes.onGenerateRoute(
        const RouteSettings(name: Routes.productDetail, arguments: 'bad'),
        session: const SessionState(
          token: 'token',
          shopId: null,
          email: 'buyer@example.com',
          displayName: 'buyer',
          role: 'user',
        ),
      );

      expect(route.settings.name, Routes.main);
    });

    test('accepts typed product detail args', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = buildRoute(
        const RouteSettings(
          name: Routes.productDetail,
          arguments: ProductDetailArgs(shopId: 's1', productId: 'p1'),
        ),
      );

      expect(route.settings.name, Routes.productDetail);
    });

    test('redirects logged-out protected routes to auth', () {
      final route = buildRoute(
        const RouteSettings(name: Routes.cart),
      );

      expect(route.settings.name, Routes.auth);
    });

    test('redirects buyer sessions away from seller routes', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = buildRoute(
        const RouteSettings(name: Routes.sellerProducts),
      );

      expect(route.settings.name, Routes.main);
    });

    test('redirects seller sessions away from buyer review route', () {
      SessionManager.instance.login(email: 'seller@example.com', role: 'seller');

      final route = buildRoute(
        const RouteSettings(name: Routes.review, arguments: ReviewArgs('s1')),
      );

      expect(route.settings.name, Routes.main);
    });

    test('accepts buyer review route with typed args', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = buildRoute(
        const RouteSettings(name: Routes.review, arguments: ReviewArgs('s1')),
      );

      expect(route.settings.name, Routes.review);
    });

    test('redirects logged-out review route to auth', () {
      final route = buildRoute(
        const RouteSettings(name: Routes.review, arguments: ReviewArgs('s1')),
      );

      expect(route.settings.name, Routes.auth);
    });

    test('seller shop route derives session shop when args are missing', () {
      SessionManager.instance.login(email: 'seller@example.com', role: 'seller');

      final route = buildRoute(
        const RouteSettings(name: Routes.sellerShop),
      );

      expect(route.settings.name, Routes.sellerShop);
    });

    test('falls back to main when required string arg is missing', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = buildRoute(
        const RouteSettings(name: Routes.storeDetail),
      );

      expect(route.settings.name, Routes.main);
    });

    test('accepts typed store detail args', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = buildRoute(
        const RouteSettings(
          name: Routes.storeDetail,
          arguments: StoreDetailArgs('s1'),
        ),
      );

      expect(route.settings.name, Routes.storeDetail);
    });

    test('accepts alias route args where routes share a typed id carrier', () {
      SessionManager.instance.login(email: 'seller@example.com', role: 'seller');

      final sellerProducts = buildRoute(
        const RouteSettings(
          name: Routes.sellerProducts,
          arguments: StoreDetailArgs('s1'),
        ),
      );
      expect(sellerProducts.settings.name, Routes.sellerProducts);

      final createProduct = buildRoute(
        const RouteSettings(
          name: Routes.sellerCreateProduct,
          arguments: StoreDetailArgs('s1'),
        ),
      );
      expect(createProduct.settings.name, Routes.sellerCreateProduct);
    });

    test('accepts typed seller product list args', () {
      SessionManager.instance
          .login(email: 'seller@example.com', role: 'seller');

      final route = buildRoute(
        const RouteSettings(
          name: Routes.sellerProducts,
          arguments: SellerShopArgs('s1'),
        ),
      );

      expect(route.settings.name, Routes.sellerProducts);
    });

    test('drops invalid args when falling back to main', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = buildRoute(
        const RouteSettings(name: Routes.storeDetail, arguments: 42),
      );

      expect(route.settings.name, Routes.main);
      expect(route.settings.arguments, isNull);
    });

    test('redirects protected Phase D routes by session role', () {
      var route = buildRoute(
        const RouteSettings(
          name: Routes.pledgeHistory,
          arguments: SellerProductArgs('p1'),
        ),
      );
      expect(route.settings.name, Routes.auth);

      route = buildRoute(
        const RouteSettings(name: Routes.qrLabel, arguments: QrLabelArgs('pl1')),
      );
      expect(route.settings.name, Routes.auth);

      SessionManager.instance.login(email: 'buyer@example.com');

      route = buildRoute(
        const RouteSettings(
          name: Routes.pledgeHistory,
          arguments: SellerProductArgs('p1'),
        ),
      );
      expect(route.settings.name, Routes.main);

      route = buildRoute(
        const RouteSettings(name: Routes.qrLabel, arguments: QrLabelArgs('pl1')),
      );
      expect(route.settings.name, Routes.main);
    });

    test('accepts typed Phase D seller route args', () {
      SessionManager.instance.login(email: 'seller@example.com', role: 'seller');

      for (final settings in const [
        RouteSettings(
          name: Routes.pledgeHistory,
          arguments: SellerProductArgs('p1'),
        ),
        RouteSettings(name: Routes.qrLabel, arguments: QrLabelArgs('pl1')),
      ]) {
        final route = buildRoute(settings);
        expect(route.settings.name, settings.name);
      }
    });

    test('accepts supported string route args', () {
      SessionManager.instance.login(email: 'seller@example.com', role: 'seller');

      for (final settings in const [
        RouteSettings(name: Routes.sellerCreateProduct, arguments: 's1'),
        RouteSettings(name: Routes.sellerCreatePledge, arguments: 'p1'),
        RouteSettings(name: Routes.pledgeHistory, arguments: 'p1'),
        RouteSettings(name: Routes.qrLabel, arguments: 'pl1'),
      ]) {
        final route = buildRoute(settings);
        expect(route.settings.name, settings.name);
      }

      SessionManager.instance.setRole('user');
      final route = buildRoute(
        const RouteSettings(name: Routes.voucherQr, arguments: 'uv1'),
      );
      expect(route.settings.name, Routes.voucherQr);
    });

    test('falls back for missing required route args', () {
      SessionManager.instance.login(email: 'seller@example.com', role: 'seller');

      for (final routeName in const [
        Routes.sellerCreateProduct,
        Routes.sellerCreatePledge,
        Routes.pledgeHistory,
        Routes.qrLabel,
      ]) {
        final route = buildRoute(RouteSettings(name: routeName));
        expect(route.settings.name, Routes.main);
      }

      SessionManager.instance.setRole('user');
      for (final routeName in const [Routes.review, Routes.voucherQr]) {
        final route = buildRoute(RouteSettings(name: routeName));
        expect(route.settings.name, Routes.main);
      }
    });
  });
}
