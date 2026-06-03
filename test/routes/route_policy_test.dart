import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/routes/route_policy.dart';

void main() {
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
}
