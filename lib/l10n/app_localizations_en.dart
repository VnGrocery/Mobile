// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'VnGrocery';

  @override
  String get authLoginTab => 'Sign in';

  @override
  String get authRegisterTab => 'Create account';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authRegisterSubtitle => 'Create an account to save product checks';

  @override
  String get authLoginInfo =>
      'Sign in to check products, view maps, and compare store prices.';

  @override
  String get authRegisterInfo =>
      'Demo accounts use sample data until a real API is connected.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authDisplayNameLabel => 'Display name';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authPasswordStrength => 'Password strength';

  @override
  String get authPasswordStrong => 'Strong';

  @override
  String get authPasswordMedium => 'Medium';

  @override
  String get authPasswordWeak => 'Weak';

  @override
  String get authForgotPasswordTitle => 'Forgot password';

  @override
  String get authResetPasswordTitle => 'Reset password';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your account email for demo verification.';

  @override
  String get authResetPasswordSubtitle =>
      'Create a new password to continue signing in.';

  @override
  String get authNewPasswordLabel => 'New password';

  @override
  String get authConfirmNewPasswordLabel => 'Confirm new password';

  @override
  String get authContinue => 'Continue';

  @override
  String get authChangePassword => 'Change password';

  @override
  String get authPasswordResetDemo => 'Demo password reset complete';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDate => 'Date';

  @override
  String get commonDecreaseQuantity => 'Decrease quantity';

  @override
  String get commonIncreaseQuantity => 'Increase quantity';

  @override
  String get accountProfileTitle => 'Profile';

  @override
  String get accountProfileUpdated => 'Profile updated';

  @override
  String get accountLogoutTitle => 'Sign out';

  @override
  String get accountLogoutPrompt => 'Are you sure you want to sign out?';

  @override
  String get accountModeSwitchedSeller => 'Switched to seller mode';

  @override
  String get accountModeSwitchedBuyer => 'Switched to buyer mode';

  @override
  String get accountCurrentMode => 'Current mode';

  @override
  String get accountSellerManagement => 'Seller management';

  @override
  String get accountBuyerActivity => 'Buyer activity';

  @override
  String get accountSettings => 'Settings';

  @override
  String get accountMyProducts => 'My products';

  @override
  String get accountStoreInfo => 'Store information';

  @override
  String get accountExploreStores => 'Explore stores';

  @override
  String get accountScanProducts => 'Scan products';

  @override
  String get accountDarkMode => 'Dark mode';

  @override
  String get accountEditProfile => 'Edit profile';

  @override
  String get accountHelpAndSupport => 'Help & support';

  @override
  String get accountHelpTitle => 'Help';

  @override
  String get accountHelpScanTitle => 'Scan products';

  @override
  String get accountHelpScanBody =>
      'Capture products and QR codes to verify recorded data.';

  @override
  String get accountHelpStoreTitle => 'Stores';

  @override
  String get accountHelpStoreBody =>
      'Browse stores, ratings, and recent products.';

  @override
  String get accountHelpContactTitle => 'Contact';

  @override
  String get accountHelpContactBody =>
      'Email support@vngrocery.local when you need help.';

  @override
  String get voucherWalletTitle => 'Voucher wallet';

  @override
  String get voucherWalletAddManualTooltip => 'Add manually';

  @override
  String voucherWalletUsableCount(Object count) {
    return '$count vouchers ready to use';
  }

  @override
  String voucherWalletTotalCount(Object count) {
    return '$count vouchers in wallet';
  }

  @override
  String get voucherWalletEmptyTitle => 'No matching vouchers yet';

  @override
  String get voucherWalletEmptyBody =>
      'Scan products, enter a code, or add vouchers manually to save them here.';

  @override
  String get voucherWalletSectionTitle => 'Your vouchers';

  @override
  String get voucherWalletShowUsed => 'Show used';

  @override
  String voucherCodeLabelInline(Object code) {
    return 'Code: $code';
  }

  @override
  String get manualVoucherTitle => 'Add manual voucher';

  @override
  String manualVoucherDemoCopied(Object format) {
    return 'Copied demo $format code into the code field';
  }

  @override
  String get manualVoucherSaved => 'Manual voucher added to wallet';

  @override
  String get manualVoucherNotice =>
      'Manual vouchers are details you enter yourself for storage and use at checkout. This content has not been verified by the store, so you are responsible for usage conditions.';

  @override
  String get manualVoucherShopLabel => 'Applicable store';

  @override
  String get manualVoucherScanQr => 'Scan QR';

  @override
  String get manualVoucherScanBarcode => 'Scan barcode';

  @override
  String get manualVoucherCodeLabel => 'Voucher code';

  @override
  String get manualVoucherCodeRequired => 'Enter voucher code';

  @override
  String get manualVoucherTitleLabel => 'Reference title';

  @override
  String get manualVoucherTitleHint => 'E.g. 20% off weekend meat purchase';

  @override
  String get manualVoucherNoteLabel => 'Your notes';

  @override
  String get manualVoucherNoteHint =>
      'Usage conditions, where you got the code, checkout notes...';

  @override
  String get manualVoucherExpiryLabel => 'Expiry date';

  @override
  String get manualVoucherChangeDate => 'Change date';

  @override
  String get manualVoucherSaveToWallet => 'Save to wallet';

  @override
  String get storeDetailTitle => 'Store details';

  @override
  String get storeDetailRecentCheckedProducts => 'Recently checked products';

  @override
  String get storeDetailCopied => 'Store details copied';

  @override
  String get storeDetailNoReceipt => 'This store has no product receipt yet';

  @override
  String get storeDetailLatestReceiptTitle => 'Recently verified product';

  @override
  String get storeDetailLatestReceiptSubtitle => 'Receipt available in history';

  @override
  String get storeDetailViewReceipt => 'View receipt';

  @override
  String get storeDetailProductsTab => 'Products';

  @override
  String get storeDetailReviewsTab => 'Reviews';

  @override
  String get storeDetailWriteReview => 'Write review';

  @override
  String get productDetailTitle => 'Product details';

  @override
  String productDetailAddedToCart(Object productName) {
    return 'Added $productName';
  }

  @override
  String get productDetailAddToCart => 'Add to cart';

  @override
  String get productDetailCounterImage => 'Counter image';

  @override
  String productDetailPricePerKg(Object price) {
    return 'Price: $price /kg';
  }

  @override
  String get productDetailLatestScoreTitle => 'LATEST SCORE';

  @override
  String get productDetailLatestScoreSubtitle =>
      'Based on recorded images and product details';

  @override
  String get productDetailCheckAction => 'Submit product photo for review';

  @override
  String get productDetailCheckActionHint =>
      'Take a photo of the price board or product to compare with the latest recorded data.';

  @override
  String get productDetailCounterInfoTitle => 'Counter information';

  @override
  String get productDetailShopCodeLabel => 'Store code';

  @override
  String get productDetailFreshnessNoteLabel => 'Product note';

  @override
  String get productDetailViewStoreInfo => 'View store details';

  @override
  String get scoreBadgeLabel => 'Score';

  @override
  String get voucherManualBadge => 'Manual';

  @override
  String get voucherUseTitle => 'Use voucher';

  @override
  String get voucherManualUseWarning =>
      'This voucher information was entered manually and has not been verified by the store. Please re-check the conditions at checkout before using it.';

  @override
  String get voucherUsed => 'Voucher used';

  @override
  String get voucherMarkUsed => 'Mark as used';

  @override
  String get voucherViewStore => 'View applicable store';

  @override
  String get voucherConfirmUseTitle => 'Confirm voucher use';

  @override
  String get voucherConfirmUseBody =>
      'A voucher can only be used once. After confirmation, it will move to the used state.';

  @override
  String get voucherMarkedUsed => 'Voucher marked as used';

  @override
  String get voucherUsageConditions => 'Usage conditions';

  @override
  String voucherRuleStore(Object shopName) {
    return 'Only valid at $shopName';
  }

  @override
  String voucherRuleMinSpend(Object amount) {
    return 'Orders from $amount';
  }
}
