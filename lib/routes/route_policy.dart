enum RouteAccess {
  public,
  authenticated,
  buyer,
  seller,
}

class RoutePolicy {
  const RoutePolicy._();

  static const publicRoutes = {
    'splash',
    'onboarding',
    'auth',
  };

  static const buyerRoutes = {
    'review',
  };

  static const sellerRoutes = {
    'seller_products',
    'seller_create_product',
    'seller_create_pledge',
    'seller_shop',
    'pledge_history',
    'qr_label',
  };

  static RouteAccess accessFor(String? routeName) {
    if (publicRoutes.contains(routeName)) return RouteAccess.public;
    if (buyerRoutes.contains(routeName)) return RouteAccess.buyer;
    if (sellerRoutes.contains(routeName)) return RouteAccess.seller;
    return RouteAccess.authenticated;
  }

  static bool canOpen({
    required String? routeName,
    required bool isLoggedIn,
    required bool isSeller,
  }) {
    switch (accessFor(routeName)) {
      case RouteAccess.public:
        return true;
      case RouteAccess.authenticated:
        return isLoggedIn;
      case RouteAccess.buyer:
        return isLoggedIn && !isSeller;
      case RouteAccess.seller:
        return isLoggedIn && isSeller;
    }
  }
}
