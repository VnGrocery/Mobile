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

    test('blocks seller routes for buyer sessions', () {
      expect(
        RoutePolicy.canOpen(
          routeName: Routes.sellerProducts,
          isLoggedIn: true,
          isSeller: false,
        ),
        isFalse,
      );
    });

    test('allows seller routes for seller sessions', () {
      expect(
        RoutePolicy.canOpen(
          routeName: Routes.sellerProducts,
          isLoggedIn: true,
          isSeller: true,
        ),
        isTrue,
      );
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
  });
}
