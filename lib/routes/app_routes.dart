import 'package:flutter/material.dart';

import 'package:vngrocery/features/account/controllers/session_state.dart';
import 'package:vngrocery/screens/splash_screen.dart';
import 'package:vngrocery/screens/onboarding_screen.dart';
import 'package:vngrocery/screens/auth_screen.dart';
import 'package:vngrocery/screens/main_screen.dart';
import 'package:vngrocery/screens/manual_voucher_screen.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/screens/activity_history_screen.dart';
import 'package:vngrocery/screens/my_checks_screen.dart';
import 'package:vngrocery/screens/seller_voucher_screen.dart';
import 'package:vngrocery/screens/change_password_screen.dart';
import 'package:vngrocery/screens/explore_map_screen.dart';
import 'package:vngrocery/screens/scanner_screen.dart';
import 'package:vngrocery/screens/product_detail_screen.dart';
import 'package:vngrocery/screens/blockchain_proof_screen.dart';
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

class BlockchainProofArgs {
  final String shopId;
  final String pledgeId;

  const BlockchainProofArgs({required this.shopId, required this.pledgeId});
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

/// The product to edit. Both ids travel because the form saves through the
/// shop-scoped endpoint, and the product itself is read from the cache the
/// seller's own list already filled.
class SellerEditProductArgs {
  final String shopId;
  final String productId;

  const SellerEditProductArgs({required this.shopId, required this.productId});
}

class Routes {
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const auth = 'auth';
  static const main = 'main';
  static const manualVoucher = 'manual_voucher';
  static const changePassword = 'change_password';
  static const myChecks = 'my_checks';
  static const activityHistory = 'activity_history';
  static const sellerEditProduct = 'seller_edit_product';
  static const sellerVouchers = 'seller_vouchers';
  static const exploreMap = 'explore_map';
  static const scan = 'scan';
  static const productDetail = 'product_detail';
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
  static const blockchainProof = 'blockchain_proof';

  static RouteFactory routeFactory(SessionState session) {
    return (settings) => onGenerateRoute(settings, session: session);
  }

  static Route<dynamic> onGenerateRoute(
    RouteSettings settings, {
    required SessionState session,
  }) {
    if (!RoutePolicy.canOpen(
      routeName: settings.name,
      isLoggedIn: session.isLoggedIn,
      isSeller: session.isSeller,
    )) {
      // Signed out is a gate worth sending someone through: they can sign in
      // and carry on. Signed in but not allowed here is not -- there is nowhere
      // better to send them, and answering with home stacks a second home
      // screen on top of the page they were reading.
      if (!session.isLoggedIn && settings.name != auth) {
        return onGenerateRoute(
          const RouteSettings(name: auth),
          session: session,
        );
      }
      return _fallbackRoute(settings, session: session);
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
      case myChecks:
        page = const MyChecksScreen();
        break;
      case activityHistory:
        page = const ActivityHistoryScreen();
        break;
      case exploreMap:
        final mapArgs =
            _routeArgs<ExploreMapArgs>(
              args,
              typed: (value) => value,
              fallback: (value) {
                final initialShopId = _optionalString(value);
                return initialShopId == null
                    ? null
                    : ExploreMapArgs(initialShopId: initialShopId);
              },
              empty: const ExploreMapArgs(),
            ) ??
            const ExploreMapArgs();
        page = ExploreMapScreen(initialShopId: mapArgs.initialShopId);
        break;
      case scan:
        page = const ScannerScreen();
        break;
      case productDetail:
        final detailArgs = _routeArgs<ProductDetailArgs>(
          args,
          typed: (value) => value,
          fallback: (value) {
            final m = _stringMap(value);
            final shopId = m?['shopId'];
            final productId = m?['productId'];
            if (_isBlank(shopId) || _isBlank(productId)) return null;
            return ProductDetailArgs(shopId: shopId!, productId: productId!);
          },
        );
        if (detailArgs == null) return _fallbackRoute(settings, session: session);
        page = ProductDetailScreen(
          shopId: detailArgs.shopId,
          productId: detailArgs.productId,
        );
        break;
      case buyerCheckResult:
        page = const BuyerCheckResultScreen();
        break;
      case storeDetail:
        final detailArgs = _singleStringRouteArg(
          args,
          typed: (value) => value,
          fromString: StoreDetailArgs.new,
        );
        if (detailArgs == null) return _fallbackRoute(settings, session: session);
        page = StoreDetailScreen(shopId: detailArgs.shopId);
        break;
      case review:
        final reviewArgs = _singleStringRouteArg(
          args,
          typed: (value) => value,
          fromString: ReviewArgs.new,
        );
        if (reviewArgs == null) return _fallbackRoute(settings, session: session);
        page = ReviewScreen(shopId: reviewArgs.shopId);
        break;
      case sellerProducts:
        page = SellerProductListScreen(
          shopId: _singleStringRouteArg(
            args,
            typed: (value) => value,
            aliases: [
              (value) => value is StoreDetailArgs
                  ? SellerShopArgs(value.shopId)
                  : null,
            ],
            fromString: SellerShopArgs.new,
          )?.shopId,
        );
        break;
      case sellerCreateProduct:
        final shopArgs = _singleStringRouteArg(
          args,
          typed: (value) => value,
          aliases: [
            (value) =>
                value is StoreDetailArgs ? SellerShopArgs(value.shopId) : null,
          ],
          fromString: SellerShopArgs.new,
        );
        if (shopArgs == null) return _fallbackRoute(settings, session: session);
        page = SellerCreateProductScreen(shopId: shopArgs.shopId);
        break;
      case sellerVouchers:
        final voucherShop = _singleStringRouteArg(
          args,
          typed: (value) => value,
          fromString: SellerShopArgs.new,
        );
        if (voucherShop == null) {
          return _fallbackRoute(settings, session: session);
        }
        page = SellerVoucherScreen(shopId: voucherShop.shopId);
        break;
      case sellerEditProduct:
        if (args is! SellerEditProductArgs) {
          return _fallbackRoute(settings, session: session);
        }
        // Read from the cache the seller's list just filled rather than
        // passing a model through route arguments.
        final editing = AppRepositories.instance.products.byIdOrNull(
          args.productId,
        );
        if (editing == null) {
          return _fallbackRoute(settings, session: session);
        }
        page = SellerCreateProductScreen(
          shopId: args.shopId,
          product: editing,
        );
        break;
      case sellerCreatePledge:
        final productArgs = _singleStringRouteArg(
          args,
          typed: (value) => value,
          fromString: SellerProductArgs.new,
        );
        if (productArgs == null) return _fallbackRoute(settings, session: session);
        page = SellerCreatePledgeScreen(productId: productArgs.productId);
        break;
      case sellerShop:
        // No shop id required. The screen reads it from the session itself,
        // and demanding one here cancelled the navigation for exactly the
        // account that needed it: 'create a shop' did nothing at all for a
        // seller who did not have one yet.
        page = const SellerShopScreen();
        break;
      case pledgeHistory:
        final productArgs = _singleStringRouteArg(
          args,
          typed: (value) => value,
          fromString: SellerProductArgs.new,
        );
        if (productArgs == null) return _fallbackRoute(settings, session: session);
        page = PledgeHistoryScreen(productId: productArgs.productId);
        break;
      case qrLabel:
        final labelArgs = _singleStringRouteArg(
          args,
          typed: (value) => value,
          fromString: QrLabelArgs.new,
        );
        if (labelArgs == null) return _fallbackRoute(settings, session: session);
        page = QrLabelScreen(pledgeId: labelArgs.pledgeId);
        break;
      case voucherWallet:
        page = const VoucherWalletScreen();
        break;
      case voucherQr:
        final qrArgs = _singleStringRouteArg(
          args,
          typed: (value) => value,
          fromString: VoucherQrArgs.new,
        );
        if (qrArgs == null) return _fallbackRoute(settings, session: session);
        page = VoucherQrScreen(userVoucherId: qrArgs.userVoucherId);
        break;
      case cart:
        page = const CartScreen();
        break;
      case blockchainProof:
        final proofArgs = _routeArgs<BlockchainProofArgs>(
          args,
          typed: (value) => value,
          fallback: (value) {
            final m = _stringMap(value);
            final shopId = m?['shopId'];
            final pledgeId = m?['pledgeId'];
            if (_isBlank(shopId) || _isBlank(pledgeId)) return null;
            return BlockchainProofArgs(shopId: shopId!, pledgeId: pledgeId!);
          },
        );
        if (proofArgs == null) return _fallbackRoute(settings, session: session);
        page = BlockchainProofScreen(
          shopId: proofArgs.shopId,
          pledgeId: proofArgs.pledgeId,
        );
        break;
      default:
        page = const SplashScreen();
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  /// Cancels a navigation that cannot be satisfied.
  ///
  /// onGenerateRoute has to return a route, so "do nothing" has to be expressed
  /// as a route that takes itself back off the stack. Answering with the home
  /// screen instead -- which is what this used to do -- pushed a second
  /// MainScreen on top of wherever the reader already was. The stack became
  /// [main, ..., main], so Back surfaced a home screen sitting in the middle of
  /// the history rather than returning where they came from.
  ///
  /// Only when there is nothing to go back to does home make sense: the app was
  /// opened straight into a route it cannot build.
  static Route<dynamic> _fallbackRoute(
    RouteSettings settings, {
    required SessionState session,
  }) {
    return PageRouteBuilder<void>(
      // The name is kept so the cancelled navigation is still identifiable;
      // the arguments are not, because they are the ones that were rejected.
      settings: RouteSettings(name: settings.name),
      // Transparent and instant, so cancelling never shows a blank frame over
      // the page the reader is still looking at.
      opaque: false,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, _, __) => _CancelledRoute(session: session),
    );
  }

  static T? _routeArgs<T>(
    Object? value, {
    required T? Function(T value) typed,
    required T? Function(Object? value) fallback,
    T? empty,
  }) {
    if (value == null) return empty;
    if (value is T) return typed(value as T);
    return fallback(value);
  }

  static T? _singleStringRouteArg<T>(
    Object? value, {
    required T? Function(T value) typed,
    required T Function(String value) fromString,
    List<T? Function(Object? value)> aliases = const [],
    T? empty,
  }) {
    return _routeArgs<T>(
      value,
      typed: typed,
      empty: empty,
      fallback: (raw) {
        for (final alias in aliases) {
          final resolved = alias(raw);
          if (resolved != null) return resolved;
        }
        final stringValue = _requiredString(raw);
        return stringValue == null ? null : fromString(stringValue);
      },
    );
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

/// The body of a cancelled navigation.
///
/// It takes itself back off the stack, and if there is nothing left underneath
/// it, it becomes the home screen instead of disappearing.
///
/// The pop used to be scheduled from the route builder after asking canPop
/// there. That question is asked too early: pushReplacementNamed and
/// pushNamedAndRemoveUntil remove the routes underneath *after* the new one is
/// pushed, so a history that looks poppable during the build can be gone by the
/// time the callback runs. Popping then emptied the navigator completely and
/// left a blank page with no way back - the app had to be killed from the task
/// switcher.
class _CancelledRoute extends StatefulWidget {
  final SessionState session;

  const _CancelledRoute({required this.session});

  @override
  State<_CancelledRoute> createState() => _CancelledRouteState();
}

class _CancelledRouteState extends State<_CancelledRoute> {
  bool _stranded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
        return;
      }
      setState(() => _stranded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_stranded) return const SizedBox.shrink();
    return widget.session.isLoggedIn ? const MainScreen() : const AuthScreen();
  }
}
