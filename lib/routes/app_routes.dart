import 'package:flutter/material.dart';

import '../data/session.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/main_screen.dart';
import '../screens/manual_voucher_screen.dart';
import '../screens/change_password_screen.dart';
import '../screens/explore_map_screen.dart';
import '../screens/scanner_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/ai_freshness_screen.dart';
import '../screens/buyer_check_result_screen.dart';
import '../screens/store_detail_screen.dart';
import '../screens/review_screen.dart';
import '../screens/seller_product_list_screen.dart';
import '../screens/seller_create_product_screen.dart';
import '../screens/seller_create_pledge_screen.dart';
import '../screens/seller_shop_screen.dart';
import '../screens/pledge_history_screen.dart';
import '../screens/qr_label_screen.dart';
import '../screens/voucher_qr_screen.dart';
import '../screens/voucher_wallet_screen.dart';
import '../screens/cart_screen.dart';
import 'route_policy.dart';

class Routes {
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const auth = 'auth';
  static const main = 'main';
  static const manualVoucher = 'manual_voucher';
  static const changePassword = 'change_password';
  static const exploreMap = 'explore_map';
  static const scan = 'scan';
  static const productDetail = 'product_detail';
  static const aiCompare = 'ai_compare';
  static const buyerCheckResult = 'buyer_check_result';
  static const storeDetail = 'store_detail';
  static const review = 'review';
  static const sellerProducts = 'seller_products';
  static const sellerCreateProduct = 'seller_create_product';
  static const sellerCreatePledge = 'seller_create_pledge';
  static const sellerShop = 'seller_shop';
  static const pledgeHistory = 'pledge_history';
  static const qrLabel = 'qr_label';
  static const voucherWallet = 'voucher_wallet';
  static const voucherQr = 'voucher_qr';
  static const cart = 'cart';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final session = SessionManager.instance;
    if (!RoutePolicy.canOpen(
      routeName: settings.name,
      isLoggedIn: session.isLoggedIn,
      isSeller: session.role == 'seller',
    )) {
      final redirect = session.isLoggedIn ? main : auth;
      return onGenerateRoute(RouteSettings(name: redirect));
    }

    final args = settings.arguments;
    Widget page;
    switch (settings.name) {
      case splash:
        page = const SplashScreen();
        break;
      case onboarding:
        page = const OnboardingScreen();
        break;
      case auth:
        page = const AuthScreen();
        break;
      case main:
        page = const MainScreen();
        break;
      case manualVoucher:
        page = const ManualVoucherScreen();
        break;
      case changePassword:
        page = const ChangePasswordScreen();
        break;
      case exploreMap:
        page = ExploreMapScreen(initialShopId: _optionalString(args));
        break;
      case scan:
        page = const ScannerScreen();
        break;
      case productDetail:
        final m = _stringMap(args);
        if (m == null || m['shopId'] == null || m['productId'] == null) {
          return _fallbackRoute(settings);
        }
        page = ProductDetailScreen(
          shopId: m['shopId']!,
          productId: m['productId']!,
        );
        break;
      case aiCompare:
        page = const AiFreshnessScreen();
        break;
      case buyerCheckResult:
        page = const BuyerCheckResultScreen();
        break;
      case storeDetail:
        final shopId = _requiredString(args);
        if (shopId == null) return _fallbackRoute(settings);
        page = StoreDetailScreen(shopId: shopId);
        break;
      case review:
        final shopId = _requiredString(args);
        if (shopId == null) return _fallbackRoute(settings);
        page = ReviewScreen(shopId: shopId);
        break;
      case sellerProducts:
        page = SellerProductListScreen(shopId: _optionalString(args));
        break;
      case sellerCreateProduct:
        final shopId = _requiredString(args);
        if (shopId == null) return _fallbackRoute(settings);
        page = SellerCreateProductScreen(shopId: shopId);
        break;
      case sellerCreatePledge:
        final productId = _requiredString(args);
        if (productId == null) return _fallbackRoute(settings);
        page = SellerCreatePledgeScreen(productId: productId);
        break;
      case sellerShop:
        page = const SellerShopScreen();
        break;
      case pledgeHistory:
        final productId = _requiredString(args);
        if (productId == null) return _fallbackRoute(settings);
        page = PledgeHistoryScreen(productId: productId);
        break;
      case qrLabel:
        final pledgeId = _requiredString(args);
        if (pledgeId == null) return _fallbackRoute(settings);
        page = QrLabelScreen(pledgeId: pledgeId);
        break;
      case voucherWallet:
        page = const VoucherWalletScreen();
        break;
      case voucherQr:
        final userVoucherId = _requiredString(args);
        if (userVoucherId == null) return _fallbackRoute(settings);
        page = VoucherQrScreen(userVoucherId: userVoucherId);
        break;
      case cart:
        page = const CartScreen();
        break;
      default:
        page = const SplashScreen();
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  static Route<dynamic> _fallbackRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const MainScreen(),
      settings: RouteSettings(name: main, arguments: settings.arguments),
    );
  }

  static String? _optionalString(Object? value) {
    return value is String && value.trim().isNotEmpty ? value : null;
  }

  static String? _requiredString(Object? value) => _optionalString(value);

  static Map<String, String>? _stringMap(Object? value) {
    if (value is! Map) return null;
    final result = <String, String>{};
    for (final entry in value.entries) {
      final key = entry.key;
      final entryValue = entry.value;
      if (key is String && entryValue is String) {
        result[key] = entryValue;
      }
    }
    return result;
  }
}
