import 'package:flutter/material.dart';

import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/screens/splash_screen.dart';
import 'package:vngrocery/screens/onboarding_screen.dart';
import 'package:vngrocery/screens/auth_screen.dart';
import 'package:vngrocery/screens/main_screen.dart';
import 'package:vngrocery/screens/manual_voucher_screen.dart';
import 'package:vngrocery/screens/change_password_screen.dart';
import 'package:vngrocery/screens/explore_map_screen.dart';
import 'package:vngrocery/screens/scanner_screen.dart';
import 'package:vngrocery/screens/product_detail_screen.dart';
import 'package:vngrocery/screens/ai_freshness_screen.dart';
import 'package:vngrocery/screens/buyer_check_result_screen.dart';
import 'package:vngrocery/screens/store_detail_screen.dart';
import 'package:vngrocery/screens/review_screen.dart';
import 'package:vngrocery/screens/seller_product_list_screen.dart';
import 'package:vngrocery/screens/seller_create_product_screen.dart';
import 'package:vngrocery/screens/seller_create_pledge_screen.dart';
import 'package:vngrocery/screens/seller_shop_screen.dart';
import 'package:vngrocery/screens/pledge_history_screen.dart';
import 'package:vngrocery/screens/qr_label_screen.dart';
import 'package:vngrocery/screens/voucher_qr_screen.dart';
import 'package:vngrocery/screens/voucher_wallet_screen.dart';
import 'package:vngrocery/screens/cart_screen.dart';
import 'route_policy.dart';

class ProductDetailArgs {
  final String shopId;
  final String productId;

  const ProductDetailArgs({required this.shopId, required this.productId});
}

class StoreDetailArgs {
  final String shopId;

  const StoreDetailArgs(this.shopId);
}

class ReviewArgs {
  final String shopId;

  const ReviewArgs(this.shopId);
}

class ExploreMapArgs {
  final String? initialShopId;

  const ExploreMapArgs({this.initialShopId});
}

class VoucherQrArgs {
  final String userVoucherId;

  const VoucherQrArgs(this.userVoucherId);
}

class QrLabelArgs {
  final String pledgeId;

  const QrLabelArgs(this.pledgeId);
}

class SellerShopArgs {
  final String shopId;

  const SellerShopArgs(this.shopId);
}

class SellerProductArgs {
  final String productId;

  const SellerProductArgs(this.productId);
}

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
      if (redirect == settings.name) return _fallbackRoute(settings);
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
        page = ExploreMapScreen(
            initialShopId: _exploreMapArgs(args)?.initialShopId);
        break;
      case scan:
        page = const ScannerScreen();
        break;
      case productDetail:
        final detailArgs = _productDetailArgs(args);
        if (detailArgs == null) return _fallbackRoute(settings);
        page = ProductDetailScreen(
          shopId: detailArgs.shopId,
          productId: detailArgs.productId,
        );
        break;
      case aiCompare:
        page = const AiFreshnessScreen();
        break;
      case buyerCheckResult:
        page = const BuyerCheckResultScreen();
        break;
      case storeDetail:
        final detailArgs = _storeDetailArgs(args);
        if (detailArgs == null) return _fallbackRoute(settings);
        page = StoreDetailScreen(shopId: detailArgs.shopId);
        break;
      case review:
        final reviewArgs = _reviewArgs(args);
        if (reviewArgs == null) return _fallbackRoute(settings);
        page = ReviewScreen(shopId: reviewArgs.shopId);
        break;
      case sellerProducts:
        page = SellerProductListScreen(shopId: _sellerShopArgs(args)?.shopId);
        break;
      case sellerCreateProduct:
        final shopArgs = _sellerShopArgs(args);
        if (shopArgs == null) return _fallbackRoute(settings);
        page = SellerCreateProductScreen(shopId: shopArgs.shopId);
        break;
      case sellerCreatePledge:
        final productArgs = _sellerProductArgs(args);
        if (productArgs == null) return _fallbackRoute(settings);
        page = SellerCreatePledgeScreen(productId: productArgs.productId);
        break;
      case sellerShop:
        page = const SellerShopScreen();
        break;
      case pledgeHistory:
        final productArgs = _sellerProductArgs(args);
        if (productArgs == null) return _fallbackRoute(settings);
        page = PledgeHistoryScreen(productId: productArgs.productId);
        break;
      case qrLabel:
        final labelArgs = _qrLabelArgs(args);
        if (labelArgs == null) return _fallbackRoute(settings);
        page = QrLabelScreen(pledgeId: labelArgs.pledgeId);
        break;
      case voucherWallet:
        page = const VoucherWalletScreen();
        break;
      case voucherQr:
        final qrArgs = _voucherQrArgs(args);
        if (qrArgs == null) return _fallbackRoute(settings);
        page = VoucherQrScreen(userVoucherId: qrArgs.userVoucherId);
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
      settings: const RouteSettings(name: main),
    );
  }

  static ExploreMapArgs? _exploreMapArgs(Object? value) {
    if (value == null) return const ExploreMapArgs();
    if (value is ExploreMapArgs) return value;
    final initialShopId = _optionalString(value);
    return initialShopId == null
        ? null
        : ExploreMapArgs(initialShopId: initialShopId);
  }

  static ProductDetailArgs? _productDetailArgs(Object? value) {
    if (value is ProductDetailArgs) return value;
    final m = _stringMap(value);
    final shopId = m?['shopId'];
    final productId = m?['productId'];
    if (_isBlank(shopId) || _isBlank(productId)) return null;
    return ProductDetailArgs(shopId: shopId!, productId: productId!);
  }

  static StoreDetailArgs? _storeDetailArgs(Object? value) {
    if (value is StoreDetailArgs) return value;
    final shopId = _requiredString(value);
    return shopId == null ? null : StoreDetailArgs(shopId);
  }

  static ReviewArgs? _reviewArgs(Object? value) {
    if (value is ReviewArgs) return value;
    final shopId = _requiredString(value);
    return shopId == null ? null : ReviewArgs(shopId);
  }

  static SellerShopArgs? _sellerShopArgs(Object? value) {
    if (value is SellerShopArgs) return value;
    if (value is StoreDetailArgs) return SellerShopArgs(value.shopId);
    final shopId = _requiredString(value);
    return shopId == null ? null : SellerShopArgs(shopId);
  }

  static SellerProductArgs? _sellerProductArgs(Object? value) {
    if (value is SellerProductArgs) return value;
    final productId = _requiredString(value);
    return productId == null ? null : SellerProductArgs(productId);
  }

  static QrLabelArgs? _qrLabelArgs(Object? value) {
    if (value is QrLabelArgs) return value;
    final pledgeId = _requiredString(value);
    return pledgeId == null ? null : QrLabelArgs(pledgeId);
  }

  static VoucherQrArgs? _voucherQrArgs(Object? value) {
    if (value is VoucherQrArgs) return value;
    final userVoucherId = _requiredString(value);
    return userVoucherId == null ? null : VoucherQrArgs(userVoucherId);
  }

  static bool _isBlank(String? value) => value == null || value.trim().isEmpty;

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
