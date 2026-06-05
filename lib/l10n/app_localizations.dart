import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// Application title.
  ///
  /// In en, this message translates to:
  /// **'VnGrocery'**
  String get appTitle;

  /// No description provided for @authLoginTab.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginTab;

  /// No description provided for @authRegisterTab.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authRegisterTab;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authWelcomeBack;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account to save product checks'**
  String get authRegisterSubtitle;

  /// No description provided for @authLoginInfo.
  ///
  /// In en, this message translates to:
  /// **'Sign in to check products, view maps, and compare store prices.'**
  String get authLoginInfo;

  /// No description provided for @authRegisterInfo.
  ///
  /// In en, this message translates to:
  /// **'Demo accounts use sample data until a real API is connected.'**
  String get authRegisterInfo;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get authDisplayNameLabel;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authPasswordStrength.
  ///
  /// In en, this message translates to:
  /// **'Password strength'**
  String get authPasswordStrength;

  /// No description provided for @authPasswordStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get authPasswordStrong;

  /// No description provided for @authPasswordMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get authPasswordMedium;

  /// No description provided for @authPasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get authPasswordWeak;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get authForgotPasswordTitle;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authResetPasswordTitle;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your account email for demo verification.'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authResetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new password to continue signing in.'**
  String get authResetPasswordSubtitle;

  /// No description provided for @authNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPasswordLabel;

  /// No description provided for @authConfirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get authConfirmNewPasswordLabel;

  /// No description provided for @authContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authContinue;

  /// No description provided for @authChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get authChangePassword;

  /// No description provided for @authPasswordResetDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo password reset complete'**
  String get authPasswordResetDemo;

  /// No description provided for @authPasswordChangedDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo password changed successfully'**
  String get authPasswordChangedDemo;

  /// No description provided for @authPasswordSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Account security'**
  String get authPasswordSecurityTitle;

  /// No description provided for @authPasswordRuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Password requirements'**
  String get authPasswordRuleTitle;

  /// No description provided for @authPasswordRuleMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get authPasswordRuleMinLength;

  /// No description provided for @authPasswordRuleComplexity.
  ///
  /// In en, this message translates to:
  /// **'Should include uppercase letters, numbers, and special characters'**
  String get authPasswordRuleComplexity;

  /// No description provided for @authPasswordRuleDifferentFromCurrent.
  ///
  /// In en, this message translates to:
  /// **'Do not reuse your current password'**
  String get authPasswordRuleDifferentFromCurrent;

  /// No description provided for @authPasswordStrengthWeakHint.
  ///
  /// In en, this message translates to:
  /// **'New password is still weak'**
  String get authPasswordStrengthWeakHint;

  /// No description provided for @authPasswordStrengthMediumHint.
  ///
  /// In en, this message translates to:
  /// **'New password is moderate'**
  String get authPasswordStrengthMediumHint;

  /// No description provided for @authPasswordStrengthStrongHint.
  ///
  /// In en, this message translates to:
  /// **'New password is strong'**
  String get authPasswordStrengthStrongHint;

  /// No description provided for @authPasswordUpdateSaving.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get authPasswordUpdateSaving;

  /// No description provided for @authPasswordUpdateSubmit.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get authPasswordUpdateSubmit;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get commonDate;

  /// No description provided for @commonDecreaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get commonDecreaseQuantity;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout cart'**
  String get cartTitle;

  /// No description provided for @cartClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get cartClearTooltip;

  /// No description provided for @cartEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty.\nAdd products to estimate totals and check vouchers.'**
  String get cartEmptyBody;

  /// No description provided for @cartExpiryNotice.
  ///
  /// In en, this message translates to:
  /// **'Items in the cart are kept for 24 hours for pricing and voucher checks.'**
  String get cartExpiryNotice;

  /// No description provided for @cartGrandSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Grand subtotal'**
  String get cartGrandSubtotal;

  /// No description provided for @cartGrandDiscount.
  ///
  /// In en, this message translates to:
  /// **'Total voucher discount'**
  String get cartGrandDiscount;

  /// No description provided for @cartGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Estimated grand total'**
  String get cartGrandTotal;

  /// No description provided for @cartUnavailableShopName.
  ///
  /// In en, this message translates to:
  /// **'Store unavailable'**
  String get cartUnavailableShopName;

  /// No description provided for @cartAppliedVoucher.
  ///
  /// In en, this message translates to:
  /// **'Applied: {code}'**
  String cartAppliedVoucher(Object code);

  /// No description provided for @cartRemoveVoucher.
  ///
  /// In en, this message translates to:
  /// **'Remove code'**
  String get cartRemoveVoucher;

  /// No description provided for @cartVoucherFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Store voucher code'**
  String get cartVoucherFieldLabel;

  /// No description provided for @cartCheckVoucher.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get cartCheckVoucher;

  /// No description provided for @cartShopSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartShopSubtotal;

  /// No description provided for @cartShopDiscount.
  ///
  /// In en, this message translates to:
  /// **'Voucher discount'**
  String get cartShopDiscount;

  /// No description provided for @cartShopTotal.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get cartShopTotal;

  /// No description provided for @cartBadgeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartBadgeTooltip;

  /// No description provided for @buyerCheckResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Check result'**
  String get buyerCheckResultTitle;

  /// No description provided for @buyerCheckViewStore.
  ///
  /// In en, this message translates to:
  /// **'View store'**
  String get buyerCheckViewStore;

  /// No description provided for @buyerCheckRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get buyerCheckRetake;

  /// No description provided for @buyerCheckVoucherSaved.
  ///
  /// In en, this message translates to:
  /// **'Voucher saved to wallet'**
  String get buyerCheckVoucherSaved;

  /// No description provided for @commonIncreaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get commonIncreaseQuantity;

  /// No description provided for @accountProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get accountProfileTitle;

  /// No description provided for @accountProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get accountProfileUpdated;

  /// No description provided for @accountLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get accountLogoutTitle;

  /// No description provided for @accountLogoutPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get accountLogoutPrompt;

  /// No description provided for @accountModeSwitchedSeller.
  ///
  /// In en, this message translates to:
  /// **'Switched to seller mode'**
  String get accountModeSwitchedSeller;

  /// No description provided for @accountModeSwitchedBuyer.
  ///
  /// In en, this message translates to:
  /// **'Switched to buyer mode'**
  String get accountModeSwitchedBuyer;

  /// No description provided for @accountCurrentMode.
  ///
  /// In en, this message translates to:
  /// **'Current mode'**
  String get accountCurrentMode;

  /// No description provided for @accountSellerManagement.
  ///
  /// In en, this message translates to:
  /// **'Seller management'**
  String get accountSellerManagement;

  /// No description provided for @accountBuyerActivity.
  ///
  /// In en, this message translates to:
  /// **'Buyer activity'**
  String get accountBuyerActivity;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get accountSettings;

  /// No description provided for @accountMyProducts.
  ///
  /// In en, this message translates to:
  /// **'My products'**
  String get accountMyProducts;

  /// No description provided for @accountStoreInfo.
  ///
  /// In en, this message translates to:
  /// **'Store information'**
  String get accountStoreInfo;

  /// No description provided for @accountExploreStores.
  ///
  /// In en, this message translates to:
  /// **'Explore stores'**
  String get accountExploreStores;

  /// No description provided for @accountScanProducts.
  ///
  /// In en, this message translates to:
  /// **'Scan products'**
  String get accountScanProducts;

  /// No description provided for @accountDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get accountDarkMode;

  /// No description provided for @accountEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get accountEditProfile;

  /// No description provided for @accountHelpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get accountHelpAndSupport;

  /// No description provided for @accountSaveProfileChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get accountSaveProfileChanges;

  /// No description provided for @accountHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get accountHelpTitle;

  /// No description provided for @accountHelpScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan products'**
  String get accountHelpScanTitle;

  /// No description provided for @accountHelpScanBody.
  ///
  /// In en, this message translates to:
  /// **'Capture products and QR codes to verify recorded data.'**
  String get accountHelpScanBody;

  /// No description provided for @accountHelpStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get accountHelpStoreTitle;

  /// No description provided for @accountHelpStoreBody.
  ///
  /// In en, this message translates to:
  /// **'Browse stores, ratings, and recent products.'**
  String get accountHelpStoreBody;

  /// No description provided for @accountHelpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get accountHelpContactTitle;

  /// No description provided for @accountHelpContactBody.
  ///
  /// In en, this message translates to:
  /// **'Email support@vngrocery.local when you need help.'**
  String get accountHelpContactBody;

  /// No description provided for @voucherWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'Voucher wallet'**
  String get voucherWalletTitle;

  /// No description provided for @voucherWalletAddManualTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get voucherWalletAddManualTooltip;

  /// No description provided for @voucherWalletUsableCount.
  ///
  /// In en, this message translates to:
  /// **'{count} vouchers ready to use'**
  String voucherWalletUsableCount(Object count);

  /// No description provided for @voucherWalletTotalCount.
  ///
  /// In en, this message translates to:
  /// **'{count} vouchers in wallet'**
  String voucherWalletTotalCount(Object count);

  /// No description provided for @voucherWalletEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching vouchers yet'**
  String get voucherWalletEmptyTitle;

  /// No description provided for @voucherWalletEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Scan products, enter a code, or add vouchers manually to save them here.'**
  String get voucherWalletEmptyBody;

  /// No description provided for @voucherWalletSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your vouchers'**
  String get voucherWalletSectionTitle;

  /// No description provided for @voucherWalletShowUsed.
  ///
  /// In en, this message translates to:
  /// **'Show used'**
  String get voucherWalletShowUsed;

  /// No description provided for @voucherCodeLabelInline.
  ///
  /// In en, this message translates to:
  /// **'Code: {code}'**
  String voucherCodeLabelInline(Object code);

  /// No description provided for @manualVoucherTitle.
  ///
  /// In en, this message translates to:
  /// **'Add manual voucher'**
  String get manualVoucherTitle;

  /// No description provided for @manualVoucherDemoCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied demo {format} code into the code field'**
  String manualVoucherDemoCopied(Object format);

  /// No description provided for @manualVoucherSaved.
  ///
  /// In en, this message translates to:
  /// **'Manual voucher added to wallet'**
  String get manualVoucherSaved;

  /// No description provided for @manualVoucherNotice.
  ///
  /// In en, this message translates to:
  /// **'Manual vouchers are details you enter yourself for storage and use at checkout. This content has not been verified by the store, so you are responsible for usage conditions.'**
  String get manualVoucherNotice;

  /// No description provided for @manualVoucherShopLabel.
  ///
  /// In en, this message translates to:
  /// **'Applicable store'**
  String get manualVoucherShopLabel;

  /// No description provided for @manualVoucherScanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get manualVoucherScanQr;

  /// No description provided for @manualVoucherScanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get manualVoucherScanBarcode;

  /// No description provided for @manualVoucherCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Voucher code'**
  String get manualVoucherCodeLabel;

  /// No description provided for @manualVoucherCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter voucher code'**
  String get manualVoucherCodeRequired;

  /// No description provided for @manualVoucherTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference title'**
  String get manualVoucherTitleLabel;

  /// No description provided for @manualVoucherTitleHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. 20% off weekend meat purchase'**
  String get manualVoucherTitleHint;

  /// No description provided for @manualVoucherNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Your notes'**
  String get manualVoucherNoteLabel;

  /// No description provided for @manualVoucherNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Usage conditions, where you got the code, checkout notes...'**
  String get manualVoucherNoteHint;

  /// No description provided for @manualVoucherExpiryLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get manualVoucherExpiryLabel;

  /// No description provided for @manualVoucherChangeDate.
  ///
  /// In en, this message translates to:
  /// **'Change date'**
  String get manualVoucherChangeDate;

  /// No description provided for @manualVoucherSaveToWallet.
  ///
  /// In en, this message translates to:
  /// **'Save to wallet'**
  String get manualVoucherSaveToWallet;

  /// No description provided for @storeDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Store details'**
  String get storeDetailTitle;

  /// No description provided for @storeDetailRecentCheckedProducts.
  ///
  /// In en, this message translates to:
  /// **'Recently checked products'**
  String get storeDetailRecentCheckedProducts;

  /// No description provided for @storeDetailCopied.
  ///
  /// In en, this message translates to:
  /// **'Store details copied'**
  String get storeDetailCopied;

  /// No description provided for @storeDetailNoReceipt.
  ///
  /// In en, this message translates to:
  /// **'This store has no product receipt yet'**
  String get storeDetailNoReceipt;

  /// No description provided for @storeDetailLatestReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently verified product'**
  String get storeDetailLatestReceiptTitle;

  /// No description provided for @storeDetailLatestReceiptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt available in history'**
  String get storeDetailLatestReceiptSubtitle;

  /// No description provided for @storeDetailViewReceipt.
  ///
  /// In en, this message translates to:
  /// **'View receipt'**
  String get storeDetailViewReceipt;

  /// No description provided for @storeDetailProductsTab.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get storeDetailProductsTab;

  /// No description provided for @storeDetailReviewsTab.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get storeDetailReviewsTab;

  /// No description provided for @storeDetailWriteReview.
  ///
  /// In en, this message translates to:
  /// **'Write review'**
  String get storeDetailWriteReview;

  /// No description provided for @productDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetailTitle;

  /// No description provided for @productDetailAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added {productName}'**
  String productDetailAddedToCart(Object productName);

  /// No description provided for @productDetailAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get productDetailAddToCart;

  /// No description provided for @productDetailCounterImage.
  ///
  /// In en, this message translates to:
  /// **'Counter image'**
  String get productDetailCounterImage;

  /// No description provided for @productDetailPricePerKg.
  ///
  /// In en, this message translates to:
  /// **'Price: {price} /kg'**
  String productDetailPricePerKg(Object price);

  /// No description provided for @productDetailLatestScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'LATEST SCORE'**
  String get productDetailLatestScoreTitle;

  /// No description provided for @productDetailLatestScoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Based on recorded images and product details'**
  String get productDetailLatestScoreSubtitle;

  /// No description provided for @productDetailCheckAction.
  ///
  /// In en, this message translates to:
  /// **'Submit product photo for review'**
  String get productDetailCheckAction;

  /// No description provided for @productDetailCheckActionHint.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of the price board or product to compare with the latest recorded data.'**
  String get productDetailCheckActionHint;

  /// No description provided for @productDetailCounterInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Counter information'**
  String get productDetailCounterInfoTitle;

  /// No description provided for @productDetailShopCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Store code'**
  String get productDetailShopCodeLabel;

  /// No description provided for @productDetailFreshnessNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Product note'**
  String get productDetailFreshnessNoteLabel;

  /// No description provided for @productDetailViewStoreInfo.
  ///
  /// In en, this message translates to:
  /// **'View store details'**
  String get productDetailViewStoreInfo;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Store review'**
  String get reviewTitle;

  /// No description provided for @reviewIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get reviewIntroTitle;

  /// No description provided for @reviewIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Your review helps the community choose better products.'**
  String get reviewIntroBody;

  /// No description provided for @reviewCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your comments here...'**
  String get reviewCommentHint;

  /// No description provided for @reviewPhotoAttached.
  ///
  /// In en, this message translates to:
  /// **'Image attached'**
  String get reviewPhotoAttached;

  /// No description provided for @reviewPhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get reviewPhotoAdd;

  /// No description provided for @reviewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit review'**
  String get reviewSubmit;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted. Thank you!'**
  String get reviewSubmitted;

  /// No description provided for @reviewSubmittedWithPhoto.
  ///
  /// In en, this message translates to:
  /// **'Review with photo submitted. Thank you!'**
  String get reviewSubmittedWithPhoto;

  /// No description provided for @reviewPhotoAttachedDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo image attached'**
  String get reviewPhotoAttachedDemo;

  /// No description provided for @reviewPhotoRemovedDemo.
  ///
  /// In en, this message translates to:
  /// **'Attached image removed'**
  String get reviewPhotoRemovedDemo;

  /// No description provided for @scoreBadgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreBadgeLabel;

  /// No description provided for @voucherManualBadge.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get voucherManualBadge;

  /// No description provided for @voucherUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Use voucher'**
  String get voucherUseTitle;

  /// No description provided for @voucherManualUseWarning.
  ///
  /// In en, this message translates to:
  /// **'This voucher information was entered manually and has not been verified by the store. Please re-check the conditions at checkout before using it.'**
  String get voucherManualUseWarning;

  /// No description provided for @voucherUsed.
  ///
  /// In en, this message translates to:
  /// **'Voucher used'**
  String get voucherUsed;

  /// No description provided for @voucherMarkUsed.
  ///
  /// In en, this message translates to:
  /// **'Mark as used'**
  String get voucherMarkUsed;

  /// No description provided for @voucherViewStore.
  ///
  /// In en, this message translates to:
  /// **'View applicable store'**
  String get voucherViewStore;

  /// No description provided for @voucherConfirmUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm voucher use'**
  String get voucherConfirmUseTitle;

  /// No description provided for @voucherConfirmUseBody.
  ///
  /// In en, this message translates to:
  /// **'A voucher can only be used once. After confirmation, it will move to the used state.'**
  String get voucherConfirmUseBody;

  /// No description provided for @voucherMarkedUsed.
  ///
  /// In en, this message translates to:
  /// **'Voucher marked as used'**
  String get voucherMarkedUsed;

  /// No description provided for @voucherUsageConditions.
  ///
  /// In en, this message translates to:
  /// **'Usage conditions'**
  String get voucherUsageConditions;

  /// No description provided for @voucherRuleStore.
  ///
  /// In en, this message translates to:
  /// **'Only valid at {shopName}'**
  String voucherRuleStore(Object shopName);

  /// No description provided for @voucherRuleMinSpend.
  ///
  /// In en, this message translates to:
  /// **'Orders from {amount}'**
  String voucherRuleMinSpend(Object amount);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
