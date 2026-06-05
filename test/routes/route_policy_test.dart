import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/routes/route_policy.dart';

void main() {
  tearDown(() {
    SessionManager.instance.logout();
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

  });

  group('Routes', () {
    test('falls back to main when product detail args are invalid', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = Routes.onGenerateRoute(
        const RouteSettings(name: Routes.productDetail, arguments: 'bad'),
      );

      expect(route.settings.name, Routes.main);
    });

    test('accepts typed product detail args', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = Routes.onGenerateRoute(
        const RouteSettings(
          name: Routes.productDetail,
          arguments: ProductDetailArgs(shopId: 's1', productId: 'p1'),
        ),
      );

      expect(route.settings.name, Routes.productDetail);
    });

    test('redirects logged-out protected routes to auth', () {
      final route = Routes.onGenerateRoute(
        const RouteSettings(name: Routes.cart),
      );

      expect(route.settings.name, Routes.auth);
    });

    test('redirects buyer sessions away from seller routes', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = Routes.onGenerateRoute(
        const RouteSettings(name: Routes.sellerProducts),
      );

      expect(route.settings.name, Routes.main);
    });

    test('falls back to main when required string arg is missing', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = Routes.onGenerateRoute(
        const RouteSettings(name: Routes.storeDetail),
      );

      expect(route.settings.name, Routes.main);
    });

    test('accepts typed store detail args', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = Routes.onGenerateRoute(
        const RouteSettings(
          name: Routes.storeDetail,
          arguments: StoreDetailArgs('s1'),
        ),
      );

      expect(route.settings.name, Routes.storeDetail);
    });

    test('accepts typed seller product list args', () {
      SessionManager.instance
          .login(email: 'seller@example.com', role: 'seller');

      final route = Routes.onGenerateRoute(
        const RouteSettings(
          name: Routes.sellerProducts,
          arguments: SellerShopArgs('s1'),
        ),
      );

      expect(route.settings.name, Routes.sellerProducts);
    });

    test('drops invalid args when falling back to main', () {
      SessionManager.instance.login(email: 'buyer@example.com');

      final route = Routes.onGenerateRoute(
        const RouteSettings(name: Routes.storeDetail, arguments: 42),
      );

      expect(route.settings.name, Routes.main);
      expect(route.settings.arguments, isNull);
    });

    test('redirects protected Phase D routes by session role', () {
      var route = Routes.onGenerateRoute(
        const RouteSettings(
          name: Routes.pledgeHistory,
          arguments: SellerProductArgs('p1'),
        ),
      );
      expect(route.settings.name, Routes.auth);

      route = Routes.onGenerateRoute(
        const RouteSettings(name: Routes.qrLabel, arguments: QrLabelArgs('pl1')),
      );
      expect(route.settings.name, Routes.auth);

      SessionManager.instance.login(email: 'buyer@example.com');

      route = Routes.onGenerateRoute(
        const RouteSettings(
          name: Routes.pledgeHistory,
          arguments: SellerProductArgs('p1'),
        ),
      );
      expect(route.settings.name, Routes.main);

      route = Routes.onGenerateRoute(
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
        final route = Routes.onGenerateRoute(settings);
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
        final route = Routes.onGenerateRoute(settings);
        expect(route.settings.name, settings.name);
      }

      SessionManager.instance.setRole('user');
      final route = Routes.onGenerateRoute(
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
        final route = Routes.onGenerateRoute(RouteSettings(name: routeName));
        expect(route.settings.name, Routes.main);
      }

      SessionManager.instance.setRole('user');
      for (final routeName in const [Routes.review, Routes.voucherQr]) {
        final route = Routes.onGenerateRoute(RouteSettings(name: routeName));
        expect(route.settings.name, Routes.main);
      }
    });
  });
}
