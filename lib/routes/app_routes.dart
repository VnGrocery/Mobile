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
        page = ExploreMapScreen(initialShopId: args as String?);
        break;
      case scan:
        page = const ScannerScreen();
        break;
      case productDetail:
        final m = args as Map<String, String>;
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
        page = StoreDetailScreen(shopId: args as String);
        break;
      case review:
        page = ReviewScreen(shopId: args as String);
        break;
      case sellerProducts:
        page = SellerProductListScreen(shopId: args as String?);
        break;
      case sellerCreateProduct:
        page = SellerCreateProductScreen(shopId: args as String);
        break;
      case sellerCreatePledge:
        page = SellerCreatePledgeScreen(productId: args as String);
        break;
      case sellerShop:
        page = const SellerShopScreen();
        break;
      case pledgeHistory:
        page = PledgeHistoryScreen(productId: args as String);
        break;
      case qrLabel:
        page = QrLabelScreen(pledgeId: args as String);
        break;
      case voucherWallet:
        page = const VoucherWalletScreen();
        break;
      case voucherQr:
        page = VoucherQrScreen(userVoucherId: args as String);
        break;
      case cart:
        page = const CartScreen();
        break;
      default:
        page = const SplashScreen();
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
