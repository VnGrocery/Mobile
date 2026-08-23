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
  /// **'Sign in to check products, view maps and compare store prices.'**
  String get authLoginInfo;

  /// No description provided for @authRegisterInfo.
  ///
  /// In en, this message translates to:
  /// **'Create an account to check products and keep your reviews.'**
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

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get validationEmailInvalid;

  /// No description provided for @validationDisplayNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Enter a display name with at least 2 characters'**
  String get validationDisplayNameTooShort;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validationPasswordTooShort;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get validationPasswordRequired;

  /// No description provided for @validationNewPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 8 characters'**
  String get validationNewPasswordTooShort;

  /// No description provided for @validationCurrentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get validationCurrentPasswordRequired;

  /// No description provided for @validationCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get validationCurrentPasswordLabel;

  /// No description provided for @validationPasswordMustDiffer.
  ///
  /// In en, this message translates to:
  /// **'New password must be different from current password'**
  String get validationPasswordMustDiffer;

  /// No description provided for @validationConfirmPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationConfirmPasswordMismatch;

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
  /// **'Enter your account email to get a reset code.'**
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

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @authChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get authChangePassword;

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

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

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

  /// No description provided for @buyerCheckLocationNear.
  ///
  /// In en, this message translates to:
  /// **'Recorded at the counter'**
  String get buyerCheckLocationNear;

  /// No description provided for @buyerCheckLocationNeedsMore.
  ///
  /// In en, this message translates to:
  /// **'More confirmations needed'**
  String get buyerCheckLocationNeedsMore;

  /// No description provided for @buyerCheckLocationNearBody.
  ///
  /// In en, this message translates to:
  /// **'You are near the store. This check is counted in recent store data.'**
  String get buyerCheckLocationNearBody;

  /// No description provided for @buyerCheckLocationNeedsMoreBody.
  ///
  /// In en, this message translates to:
  /// **'You are not near the store. This check is for reference only.'**
  String get buyerCheckLocationNeedsMoreBody;

  /// No description provided for @buyerCheckVerdictTitle.
  ///
  /// In en, this message translates to:
  /// **'Compared with the latest data'**
  String get buyerCheckVerdictTitle;

  /// No description provided for @buyerCheckVerdictValue.
  ///
  /// In en, this message translates to:
  /// **'Result: {verdict}'**
  String buyerCheckVerdictValue(Object verdict);

  /// No description provided for @buyerCheckVerdictBody.
  ///
  /// In en, this message translates to:
  /// **'This result is based on the photo you submitted and the recorded information.'**
  String get buyerCheckVerdictBody;

  /// No description provided for @buyerCheckVoucherTitle.
  ///
  /// In en, this message translates to:
  /// **'Check voucher'**
  String get buyerCheckVoucherTitle;

  /// No description provided for @buyerCheckVoucherCodeHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. FRESH20'**
  String get buyerCheckVoucherCodeHint;

  /// No description provided for @buyerCheckVoucherDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get buyerCheckVoucherDiscount;

  /// No description provided for @buyerCheckVoucherRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get buyerCheckVoucherRemaining;

  /// No description provided for @buyerCheckOpenWallet.
  ///
  /// In en, this message translates to:
  /// **'Open wallet'**
  String get buyerCheckOpenWallet;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore stores'**
  String get exploreTitle;

  /// No description provided for @exploreStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get exploreStoreTitle;

  /// No description provided for @exploreNearbyStoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Stores near you'**
  String get exploreNearbyStoresTitle;

  /// No description provided for @exploreAllStoresTitle.
  ///
  /// In en, this message translates to:
  /// **'All stores'**
  String get exploreAllStoresTitle;

  /// No description provided for @exploreNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matching stores found'**
  String get exploreNoResults;

  /// No description provided for @exploreSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by store name or address...'**
  String get exploreSearchHint;

  /// No description provided for @exploreDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get exploreDirections;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get exploreYourLocation;

  /// No description provided for @exploreOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Open map'**
  String get exploreOpenMap;

  /// No description provided for @exploreTopRatedBadge.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get exploreTopRatedBadge;

  /// No description provided for @exploreRatingLabel.
  ///
  /// In en, this message translates to:
  /// **' {rating} rating points'**
  String exploreRatingLabel(Object rating);

  /// No description provided for @exploreFilterTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get exploreFilterTopRated;

  /// No description provided for @exploreFilterRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get exploreFilterRecorded;

  /// Explore chip that orders shops by distance.
  ///
  /// In en, this message translates to:
  /// **'Near you'**
  String get exploreFilterNearby;

  /// No description provided for @exploreFilterNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get exploreFilterNewest;

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

  /// No description provided for @sellerShopSaved.
  ///
  /// In en, this message translates to:
  /// **'Store details saved'**
  String get sellerShopSaved;

  /// No description provided for @sellerShopNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get sellerShopNameLabel;

  /// No description provided for @sellerShopDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sellerShopDescriptionLabel;

  /// No description provided for @sellerShopAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get sellerShopAddressLabel;

  /// No description provided for @sellerShopFootnote.
  ///
  /// In en, this message translates to:
  /// **'This information is shown on the store page and product labels.'**
  String get sellerShopFootnote;

  /// No description provided for @sellerShopNotRatedYet.
  ///
  /// In en, this message translates to:
  /// **'Not rated yet'**
  String get sellerShopNotRatedYet;

  /// No description provided for @sellerShopGradeSummary.
  ///
  /// In en, this message translates to:
  /// **'Grade {grade} - {rating} points'**
  String sellerShopGradeSummary(Object grade, Object rating);

  /// No description provided for @sellerShopPledgesMetric.
  ///
  /// In en, this message translates to:
  /// **'Pledges'**
  String get sellerShopPledgesMetric;

  /// No description provided for @sellerShopWarningsMetric.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get sellerShopWarningsMetric;

  /// No description provided for @sellerProductNoShop.
  ///
  /// In en, this message translates to:
  /// **'Your account does not have a store yet.'**
  String get sellerProductNoShop;

  /// No description provided for @sellerProductCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Add new product'**
  String get sellerProductCreateTitle;

  /// No description provided for @sellerProductSaved.
  ///
  /// In en, this message translates to:
  /// **'Product published'**
  String get sellerProductSaved;

  /// No description provided for @sellerProductSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the product. Check the connection and try again.'**
  String get sellerProductSaveFailed;

  /// No description provided for @sellerProductImageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'The photo could not be uploaded. The product was saved without it.'**
  String get sellerProductImageUploadFailed;

  /// No description provided for @sellerProductImageRemoved.
  ///
  /// In en, this message translates to:
  /// **'Product image removed'**
  String get sellerProductImageRemoved;

  /// No description provided for @sellerProductStateAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get sellerProductStateAll;

  /// No description provided for @sellerProductStatePublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get sellerProductStatePublished;

  /// No description provided for @sellerProductStateDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get sellerProductStateDraft;

  /// No description provided for @sellerProductStateArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get sellerProductStateArchived;

  /// No description provided for @sellerCategoryBeef.
  ///
  /// In en, this message translates to:
  /// **'Beef'**
  String get sellerCategoryBeef;

  /// No description provided for @sellerCategoryPork.
  ///
  /// In en, this message translates to:
  /// **'Pork'**
  String get sellerCategoryPork;

  /// No description provided for @sellerCategoryChicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get sellerCategoryChicken;

  /// No description provided for @sellerCategorySeafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get sellerCategorySeafood;

  /// No description provided for @sellerCategoryPoultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get sellerCategoryPoultry;

  /// No description provided for @sellerCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sellerCategoryOther;

  /// No description provided for @sellerProductFreshnessWithImage.
  ///
  /// In en, this message translates to:
  /// **'New product, photo attached.'**
  String get sellerProductFreshnessWithImage;

  /// No description provided for @sellerProductFreshnessWithoutImage.
  ///
  /// In en, this message translates to:
  /// **'Newly created product.'**
  String get sellerProductFreshnessWithoutImage;

  /// No description provided for @sellerProductImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Product image'**
  String get sellerProductImageTitle;

  /// No description provided for @sellerProductImageReady.
  ///
  /// In en, this message translates to:
  /// **'Photo attached'**
  String get sellerProductImageReady;

  /// No description provided for @sellerProductImageSelect.
  ///
  /// In en, this message translates to:
  /// **'Take a product photo'**
  String get sellerProductImageSelect;

  /// No description provided for @sellerProductNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get sellerProductNameLabel;

  /// No description provided for @sellerProductPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sellerProductPriceLabel;

  /// No description provided for @sellerProductCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get sellerProductCategoryLabel;

  /// No description provided for @sellerProductDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sellerProductDescriptionLabel;

  /// No description provided for @sellerProductTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get sellerProductTagsLabel;

  /// No description provided for @sellerProductTagsHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. fresh, clean, organic'**
  String get sellerProductTagsHint;

  /// No description provided for @sellerProductSave.
  ///
  /// In en, this message translates to:
  /// **'Save product'**
  String get sellerProductSave;

  /// No description provided for @sellerProductActionViewDetail.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get sellerProductActionViewDetail;

  /// No description provided for @sellerProductActionViewHistory.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get sellerProductActionViewHistory;

  /// No description provided for @sellerProductActionAddPledge.
  ///
  /// In en, this message translates to:
  /// **'Add pledge'**
  String get sellerProductActionAddPledge;

  /// No description provided for @sellerProductEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get sellerProductEmpty;

  /// No description provided for @sellerProductCategoryValue.
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String sellerProductCategoryValue(Object category);

  /// No description provided for @sellerProductHistoryShort.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get sellerProductHistoryShort;

  /// No description provided for @sellerProductAddPledgeShort.
  ///
  /// In en, this message translates to:
  /// **'Add pledge'**
  String get sellerProductAddPledgeShort;

  /// No description provided for @sellerPledgeCategoryBeef.
  ///
  /// In en, this message translates to:
  /// **'Beef'**
  String get sellerPledgeCategoryBeef;

  /// No description provided for @sellerPledgeCategoryPork.
  ///
  /// In en, this message translates to:
  /// **'Pork'**
  String get sellerPledgeCategoryPork;

  /// No description provided for @sellerPledgeCategoryChicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get sellerPledgeCategoryChicken;

  /// No description provided for @sellerPledgeCategorySeafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get sellerPledgeCategorySeafood;

  /// No description provided for @sellerPledgeCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sellerPledgeCategoryOther;

  /// No description provided for @sellerPledgeStepCapture.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Capture product photo'**
  String get sellerPledgeStepCapture;

  /// No description provided for @sellerPledgeStepEvaluate.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Evaluate product'**
  String get sellerPledgeStepEvaluate;

  /// No description provided for @sellerPledgeStepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Confirm pledge'**
  String get sellerPledgeStepConfirm;

  /// No description provided for @sellerPledgeRecordTimeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get sellerPledgeRecordTimeJustNow;

  /// No description provided for @sellerPledgeRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Seller added a new pledge'**
  String get sellerPledgeRecordTitle;

  /// No description provided for @sellerPledgeRecordDescription.
  ///
  /// In en, this message translates to:
  /// **'Score {score}/10 for category: {category}.'**
  String sellerPledgeRecordDescription(Object score, Object category);

  /// No description provided for @sellerPledgeCaptureAction.
  ///
  /// In en, this message translates to:
  /// **'Capture product photo'**
  String get sellerPledgeCaptureAction;

  /// No description provided for @sellerPledgeSuggestedScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'SUGGESTED SCORE FROM IMAGE'**
  String get sellerPledgeSuggestedScoreTitle;

  /// No description provided for @sellerPledgeSellerScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'SELLER SCORE'**
  String get sellerPledgeSellerScoreTitle;

  /// No description provided for @sellerPledgeScoreRange.
  ///
  /// In en, this message translates to:
  /// **'A score from 0 to 10'**
  String get sellerPledgeScoreRange;

  /// No description provided for @sellerPledgeSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the record. Check the connection and try again.'**
  String get sellerPledgeSaveFailed;

  /// No description provided for @sellerPledgeSellerScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter score (0-10)'**
  String get sellerPledgeSellerScoreLabel;

  /// No description provided for @sellerPledgeContinueConfirm.
  ///
  /// In en, this message translates to:
  /// **'Continue to confirm'**
  String get sellerPledgeContinueConfirm;

  /// No description provided for @sellerPledgeCategoryValue.
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String sellerPledgeCategoryValue(Object category);

  /// No description provided for @sellerPledgeRecordContentTitle.
  ///
  /// In en, this message translates to:
  /// **'PLEDGE CONTENT'**
  String get sellerPledgeRecordContentTitle;

  /// No description provided for @sellerPledgeRecordPreview.
  ///
  /// In en, this message translates to:
  /// **'I recorded this product at the counter with a score of {score}.'**
  String sellerPledgeRecordPreview(Object score);

  /// No description provided for @sellerPledgeConfirmSave.
  ///
  /// In en, this message translates to:
  /// **'Confirm & save pledge'**
  String get sellerPledgeConfirmSave;

  /// No description provided for @sellerPledgeSaved.
  ///
  /// In en, this message translates to:
  /// **'Product pledge saved.'**
  String get sellerPledgeSaved;

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

  /// No description provided for @scannerFrameHint.
  ///
  /// In en, this message translates to:
  /// **'Place the QR code or product tag inside the frame'**
  String get scannerFrameHint;

  /// No description provided for @scannerCheckingAction.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get scannerCheckingAction;

  /// No description provided for @scannerSimulateAction.
  ///
  /// In en, this message translates to:
  /// **'Capture & analyze with AI'**
  String get scannerSimulateAction;

  /// No description provided for @scannerStatusVerifying.
  ///
  /// In en, this message translates to:
  /// **'Checking counter location...'**
  String get scannerStatusVerifying;

  /// No description provided for @scannerStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to verify product'**
  String get scannerStatusReady;

  /// No description provided for @scannerOverlayVerifying.
  ///
  /// In en, this message translates to:
  /// **'Checking product...'**
  String get scannerOverlayVerifying;

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

  /// No description provided for @commonBuyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get commonBuyer;

  /// No description provided for @commonSeller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get commonSeller;

  /// No description provided for @accountSellerModeBody.
  ///
  /// In en, this message translates to:
  /// **'Seller mode: manage store, products, and pledges.'**
  String get accountSellerModeBody;

  /// No description provided for @accountBuyerModeBody.
  ///
  /// In en, this message translates to:
  /// **'Buyer mode: explore, scan codes, and check products.'**
  String get accountBuyerModeBody;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get homeGreeting;

  /// No description provided for @homeLocationDistrict1.
  ///
  /// In en, this message translates to:
  /// **'District 1'**
  String get homeLocationDistrict1;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search stores, products...'**
  String get homeSearchHint;

  /// No description provided for @homeScanHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Check against recorded data'**
  String get homeScanHeroBody;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get homeCategoriesTitle;

  /// No description provided for @homeCategoryPork.
  ///
  /// In en, this message translates to:
  /// **'Pork'**
  String get homeCategoryPork;

  /// No description provided for @homeCategoryBeef.
  ///
  /// In en, this message translates to:
  /// **'Beef'**
  String get homeCategoryBeef;

  /// No description provided for @homeCategoryPoultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get homeCategoryPoultry;

  /// No description provided for @homeCategorySeafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get homeCategorySeafood;

  /// No description provided for @homeTopRatedStoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Top-rated stores'**
  String get homeTopRatedStoresTitle;

  /// No description provided for @homeRecentChecksTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently checked products'**
  String get homeRecentChecksTitle;

  /// No description provided for @homeShopRatingValue.
  ///
  /// In en, this message translates to:
  /// **' {rating}'**
  String homeShopRatingValue(Object rating);

  /// No description provided for @homeShopReviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String homeShopReviewCount(Object count);

  /// No description provided for @aiFreshnessTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit check photo'**
  String get aiFreshnessTitle;

  /// No description provided for @aiFreshnessHeading.
  ///
  /// In en, this message translates to:
  /// **'Take a product photo at the counter'**
  String get aiFreshnessHeading;

  /// No description provided for @aiFreshnessBody.
  ///
  /// In en, this message translates to:
  /// **'This photo helps compare with recently recorded information.'**
  String get aiFreshnessBody;

  /// No description provided for @aiFreshnessAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Comparing with latest data...'**
  String get aiFreshnessAnalyzing;

  /// No description provided for @aiFreshnessAction.
  ///
  /// In en, this message translates to:
  /// **'Take photo & check'**
  String get aiFreshnessAction;

  /// No description provided for @pledgeOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Seller overview'**
  String get pledgeOverviewTitle;

  /// No description provided for @pledgeOverviewMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Store metrics'**
  String get pledgeOverviewMetricsTitle;

  /// No description provided for @pledgeOverviewHint.
  ///
  /// In en, this message translates to:
  /// **'Shoot in good light so the score is stable. Each record is anchored on the blockchain.'**
  String get pledgeOverviewHint;

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

  /// No description provided for @qrLabelTitle.
  ///
  /// In en, this message translates to:
  /// **'Product QR code'**
  String get qrLabelTitle;

  /// No description provided for @qrLabelCopied.
  ///
  /// In en, this message translates to:
  /// **'QR label content copied'**
  String get qrLabelCopied;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check prices and products near you'**
  String get splashSubtitle;

  /// No description provided for @splashFootnote.
  ///
  /// In en, this message translates to:
  /// **'Data from store counters and the community'**
  String get splashFootnote;

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

  /// No description provided for @storeShareSummary.
  ///
  /// In en, this message translates to:
  /// **'{rating} rating points - {reviewCount} reviews'**
  String storeShareSummary(Object rating, Object reviewCount);

  /// No description provided for @storeProductShopLabel.
  ///
  /// In en, this message translates to:
  /// **'Store: {shopId}'**
  String storeProductShopLabel(Object shopId);

  /// No description provided for @storeProductScore.
  ///
  /// In en, this message translates to:
  /// **'{score} points'**
  String storeProductScore(Object score);

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

  /// Shown after attaching a review photo.
  ///
  /// In en, this message translates to:
  /// **'Photo attached'**
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

  /// Trust badge label when the pledge hash matches the on-chain record.
  ///
  /// In en, this message translates to:
  /// **'Verified on blockchain'**
  String get trustProofVerifiedLabel;

  /// Trust badge label while the hash is still being anchored.
  ///
  /// In en, this message translates to:
  /// **'Anchoring to blockchain'**
  String get trustProofPendingLabel;

  /// Trust badge label when the stored hash disagrees with the chain.
  ///
  /// In en, this message translates to:
  /// **'Mismatch detected'**
  String get trustProofWarningLabel;

  /// Trust badge label when the pledge has been revoked.
  ///
  /// In en, this message translates to:
  /// **'Pledge revoked'**
  String get trustProofRevokedLabel;

  /// Trust badge label when the proof could not be resolved.
  ///
  /// In en, this message translates to:
  /// **'Not verified yet'**
  String get trustProofUnknownLabel;

  /// Explanation shown with the verified badge.
  ///
  /// In en, this message translates to:
  /// **'The freshness pledge was anchored on the blockchain and still matches.'**
  String get trustProofVerifiedSummary;

  /// Explanation shown with the pending badge.
  ///
  /// In en, this message translates to:
  /// **'The pledge was created but has not finished anchoring yet.'**
  String get trustProofPendingSummary;

  /// Explanation shown with the warning badge.
  ///
  /// In en, this message translates to:
  /// **'The stored data no longer matches the record on the blockchain.'**
  String get trustProofWarningSummary;

  /// Explanation shown with the revoked badge.
  ///
  /// In en, this message translates to:
  /// **'This pledge was withdrawn and should no longer be trusted.'**
  String get trustProofRevokedSummary;

  /// Explanation shown with the neutral badge.
  ///
  /// In en, this message translates to:
  /// **'The blockchain record for this pledge could not be checked.'**
  String get trustProofUnknownSummary;

  /// Trust grade band for scores 85 and above.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get trustGradeExcellent;

  /// Trust grade band for scores 70 to 84.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get trustGradeGood;

  /// Trust grade band for scores 55 to 69.
  ///
  /// In en, this message translates to:
  /// **'Needs watching'**
  String get trustGradeWatch;

  /// Trust grade band for scores below 55.
  ///
  /// In en, this message translates to:
  /// **'Risky'**
  String get trustGradeRisk;

  /// Heading of the trust score card.
  ///
  /// In en, this message translates to:
  /// **'Trust score'**
  String get trustScoreTitle;

  /// Shown instead of a score when the shop has no signal.
  ///
  /// In en, this message translates to:
  /// **'Not enough data to rate this shop yet.'**
  String get trustScoreNoData;

  /// Heading above the sub-score bars.
  ///
  /// In en, this message translates to:
  /// **'How this score is made up'**
  String get trustScoreBreakdown;

  /// Heading above the reason list.
  ///
  /// In en, this message translates to:
  /// **'Why'**
  String get trustScoreReasons;

  /// Footnote naming the server formula version.
  ///
  /// In en, this message translates to:
  /// **'Formula {version}'**
  String trustScoreFormula(Object version);

  /// Sub-score name.
  ///
  /// In en, this message translates to:
  /// **'Seller pledges'**
  String get trustComponentPledge;

  /// Sub-score name.
  ///
  /// In en, this message translates to:
  /// **'Customer reviews'**
  String get trustComponentReview;

  /// Sub-score name.
  ///
  /// In en, this message translates to:
  /// **'Buyer checks'**
  String get trustComponentBuyerCheck;

  /// Sub-score name.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get trustComponentConsistency;

  /// Sub-score name.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get trustComponentRecency;

  /// Sub-score name.
  ///
  /// In en, this message translates to:
  /// **'Signal coverage'**
  String get trustComponentCoverage;

  /// Reason code partial_trust_data.
  ///
  /// In en, this message translates to:
  /// **'Only part of the trust data is available'**
  String get trustReasonPartialTrustData;

  /// Reason code no_customer_reviews.
  ///
  /// In en, this message translates to:
  /// **'No customer reviews yet'**
  String get trustReasonNoCustomerReviews;

  /// Reason code no_buyer_checks.
  ///
  /// In en, this message translates to:
  /// **'No buyer has verified a product yet'**
  String get trustReasonNoBuyerChecks;

  /// Reason code no_eligible_buyer_checks.
  ///
  /// In en, this message translates to:
  /// **'No buyer check counted towards the score'**
  String get trustReasonNoEligibleBuyerChecks;

  /// Reason code buyer_checks_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Buyer checks confirmed the seller pledges'**
  String get trustReasonBuyerChecksConfirmed;

  /// Reason code buyer_checks_high_risk.
  ///
  /// In en, this message translates to:
  /// **'Buyer checks flagged a high risk'**
  String get trustReasonBuyerChecksHighRisk;

  /// Reason code buyer_checks_show_consistency_issues.
  ///
  /// In en, this message translates to:
  /// **'Buyer checks disagree with the pledges'**
  String get trustReasonBuyerChecksConsistencyIssues;

  /// Reason code duplicate_buyer_checks_discounted.
  ///
  /// In en, this message translates to:
  /// **'Duplicate buyer checks were discounted'**
  String get trustReasonDuplicateBuyerChecks;

  /// Reason code pledges_consistent_with_buyer_checks.
  ///
  /// In en, this message translates to:
  /// **'Pledges are consistent with buyer checks'**
  String get trustReasonPledgesConsistent;

  /// Reason code limited_consistency_data.
  ///
  /// In en, this message translates to:
  /// **'Not enough data to judge consistency'**
  String get trustReasonLimitedConsistencyData;

  /// Reason code no_consistency_signals.
  ///
  /// In en, this message translates to:
  /// **'No consistency signals available'**
  String get trustReasonNoConsistencySignals;

  /// Reason code limited_signal_coverage.
  ///
  /// In en, this message translates to:
  /// **'Trust signals cover only a few products'**
  String get trustReasonLimitedSignalCoverage;

  /// Reason code recent_activity_available.
  ///
  /// In en, this message translates to:
  /// **'The shop has been active recently'**
  String get trustReasonRecentActivity;

  /// Reason code no_recent_activity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity from this shop'**
  String get trustReasonNoRecentActivity;

  /// Reason code no_pledge.
  ///
  /// In en, this message translates to:
  /// **'This product has no freshness pledge'**
  String get trustReasonNoPledge;

  /// Reason code no_seller_pledges.
  ///
  /// In en, this message translates to:
  /// **'The seller has not made any pledge yet'**
  String get trustReasonNoSellerPledges;

  /// Reason code some_pledges_low_confidence.
  ///
  /// In en, this message translates to:
  /// **'Some pledges have low confidence'**
  String get trustReasonSomePledgesLowConfidence;

  /// Title of the blockchain proof screen.
  ///
  /// In en, this message translates to:
  /// **'Blockchain certificate'**
  String get blockchainProofTitle;

  /// Label for the pledge id row.
  ///
  /// In en, this message translates to:
  /// **'Pledge'**
  String get blockchainProofPledge;

  /// Label for the on-chain transaction hash.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get blockchainProofTxHash;

  /// Label for the block number.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get blockchainProofBlock;

  /// Label for the pledge data hash.
  ///
  /// In en, this message translates to:
  /// **'Data hash'**
  String get blockchainProofDataHash;

  /// Label for the anchoring timestamp.
  ///
  /// In en, this message translates to:
  /// **'Anchored at'**
  String get blockchainProofAnchoredAt;

  /// Label for the on-chain match row.
  ///
  /// In en, this message translates to:
  /// **'Hash matches the chain'**
  String get blockchainProofMatch;

  /// Affirmative value.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get blockchainProofYes;

  /// Negative value.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get blockchainProofNo;

  /// Shown when nothing has been anchored yet.
  ///
  /// In en, this message translates to:
  /// **'This pledge has no record on the blockchain yet.'**
  String get blockchainProofNoRecord;

  /// Button that reloads the proof.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get blockchainProofRefresh;

  /// Snackbar after copying a value.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get blockchainProofCopied;

  /// Hint under the certificate rows.
  ///
  /// In en, this message translates to:
  /// **'Tap a value to copy it'**
  String get blockchainProofCopyHint;

  /// Label for the pledged score row.
  ///
  /// In en, this message translates to:
  /// **'Pledged freshness'**
  String get blockchainProofScore;

  /// Heading of the comparison card.
  ///
  /// In en, this message translates to:
  /// **'Pledge vs. what we measured'**
  String get buyerCheckCompareTitle;

  /// Label for the pledged score.
  ///
  /// In en, this message translates to:
  /// **'Seller pledged'**
  String get buyerCheckPledged;

  /// Label for the measured score.
  ///
  /// In en, this message translates to:
  /// **'Measured now'**
  String get buyerCheckMeasured;

  /// Label for the score difference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get buyerCheckDelta;

  /// Label for the category match row.
  ///
  /// In en, this message translates to:
  /// **'Product type matches'**
  String get buyerCheckCategoryMatch;

  /// Shown when the check had no pledge.
  ///
  /// In en, this message translates to:
  /// **'This product has no pledge to compare against.'**
  String get buyerCheckNoPledge;

  /// Shown when the server marks the check trusted.
  ///
  /// In en, this message translates to:
  /// **'Consistent with the pledge'**
  String get buyerCheckTrusted;

  /// Shown when the check is not trusted.
  ///
  /// In en, this message translates to:
  /// **'Does not match the pledge'**
  String get buyerCheckNotTrusted;

  /// Footnote with the model confidence.
  ///
  /// In en, this message translates to:
  /// **'AI confidence {percent}%'**
  String buyerCheckConfidence(Object percent);

  /// Title of the QR scanner screen.
  ///
  /// In en, this message translates to:
  /// **'Scan bundle code'**
  String get qrScanTitle;

  /// Instruction under the scan frame.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the code on the label'**
  String get qrScanHint;

  /// Shown when the scanned code is unrelated.
  ///
  /// In en, this message translates to:
  /// **'This is not a VnGrocery code'**
  String get qrScanNotOurCode;

  /// Shown when the token exp has passed.
  ///
  /// In en, this message translates to:
  /// **'This code has expired, ask the seller for a new label'**
  String get qrScanExpired;

  /// Shown for an unknown qrVersion.
  ///
  /// In en, this message translates to:
  /// **'This code needs a newer app version'**
  String get qrScanUnsupported;

  /// Shown when the scanner fails to start.
  ///
  /// In en, this message translates to:
  /// **'Cannot open the camera'**
  String get qrScanCameraError;

  /// Shown while the buyer check runs.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get qrScanChecking;

  /// Bottom navigation and side menu label.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation and side menu label.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// Bottom navigation and side menu label.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScanProducts;

  /// Bottom navigation and side menu label.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get navStores;

  /// Bottom navigation and side menu label.
  ///
  /// In en, this message translates to:
  /// **'Vouchers'**
  String get navVoucherWallet;

  /// Bottom navigation and side menu label.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// Bottom navigation and side menu label.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navSellerOverview;

  /// Bottom navigation and side menu label.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get navSellerProducts;

  /// Bottom navigation and side menu label.
  ///
  /// In en, this message translates to:
  /// **'My store'**
  String get navSellerStore;

  /// Onboarding slide copy.
  ///
  /// In en, this message translates to:
  /// **'See the data behind a product'**
  String get onboardingTitle1;

  /// Onboarding slide copy.
  ///
  /// In en, this message translates to:
  /// **'Every product carries a freshness score and a clear record of its history.'**
  String get onboardingBody1;

  /// Onboarding slide copy.
  ///
  /// In en, this message translates to:
  /// **'Check it with a photo'**
  String get onboardingTitle2;

  /// Onboarding slide copy.
  ///
  /// In en, this message translates to:
  /// **'Scan the label or take a photo at the counter to compare with the latest record.'**
  String get onboardingBody2;

  /// Onboarding slide copy.
  ///
  /// In en, this message translates to:
  /// **'Decide with confidence'**
  String get onboardingTitle3;

  /// Onboarding slide copy.
  ///
  /// In en, this message translates to:
  /// **'Comparing is easier when the information comes from real recorded checks.'**
  String get onboardingBody3;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Store status'**
  String get sellerShopStatusTitle;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sellerStatusLabel;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Total records'**
  String get sellerTotalRecords;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Latest receipt'**
  String get sellerLatestReceipt;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get sellerNone;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get sellerNeedsReview;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get sellerStable;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Record a product'**
  String get sellerAddRecordTitle;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Pick a product and save its details at the counter.'**
  String get sellerAddRecordBody;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Create a product before recording.'**
  String get sellerNeedProductFirst;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get sellerProductsLabel;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get sellerHistoryLabel;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get sellerTrustLabel;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Records today'**
  String get sellerRecordsToday;

  /// Seller dashboard copy.
  ///
  /// In en, this message translates to:
  /// **'Buyer alerts'**
  String get sellerBuyerAlerts;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Save {value}%'**
  String voucherDiscountPercent(Object value);

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Save {amount}'**
  String voucherDiscountAmount(Object amount);

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Manually entered'**
  String get voucherManualInfo;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'From {amount}'**
  String voucherMinSpendFrom(Object amount);

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get voucherExpiredLabel;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Usable'**
  String get voucherUsableLabel;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Ready to use'**
  String get voucherReadyLabel;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Based on what you entered'**
  String get voucherPerYourInput;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Your QR code is ready'**
  String get qrLabelReadyTitle;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Print it and stick it on the packaging.'**
  String get qrLabelReadyBody;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Record: {id}'**
  String qrLabelRecordId(Object id);

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Scan to check this product'**
  String get qrLabelScanHint;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get qrLabelBackHome;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get homeAddToCart;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Added {name}'**
  String homeAddedToCart(Object name);

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Recently checked products'**
  String get homeRecentChecks;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Product timeline'**
  String get pledgeTimelineTitle;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get pledgeHistoryEmpty;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Original receipt: {id}'**
  String pledgeOriginalReceipt(Object id);

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'No camera found'**
  String get scannerNoCamera;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Opening the camera...'**
  String get scannerOpeningCamera;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {percent}%'**
  String scannerConfidence(Object percent);

  /// Short status chip for a used voucher.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get voucherUsedShort;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScanShort;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Data from counters and the community'**
  String get sideMenuFootnote;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get roleSeller;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get roleBuyer;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get voucherBarcode;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Stores near you'**
  String get exploreNearbyTitle;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'View store'**
  String get exploreViewStore;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Find stores near you'**
  String get exploreSearchNearby;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Scan a valid pledge label before checking.'**
  String get buyerCheckScanFirst;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorAccountDeleted.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
  String get authErrorAccountDeleted;

  /// No description provided for @authErrorEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'That email is already registered'**
  String get authErrorEmailTaken;

  /// No description provided for @authErrorInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'Check the email and password. Passwords need at least 8 characters.'**
  String get authErrorInvalidInput;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check the connection and try again.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed. Please try again.'**
  String get authErrorGeneric;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Could not get a Google ID token'**
  String get authGoogleTokenError;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Record history'**
  String get pledgeHistoryTitle;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreLabel;

  /// App copy.
  ///
  /// In en, this message translates to:
  /// **'VnGrocery Check\nRecord: {pledgeId}\nScan the code to check this product'**
  String qrLabelClipboard(Object pledgeId);

  /// Subtitle under the seller dashboard heading.
  ///
  /// In en, this message translates to:
  /// **'Seller mode'**
  String get sellerModeSubtitle;

  /// AI confidence readout.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {percent}%'**
  String scannerConfidenceValue(Object percent);

  /// Label for the fresh_produce category key.
  ///
  /// In en, this message translates to:
  /// **'Fresh produce'**
  String get homeCategoryFreshProduce;

  /// Label for the meat category key.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get homeCategoryMeat;

  /// Label for the vegetables category key.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get homeCategoryVegetables;

  /// Label for the fruit category key.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get homeCategoryFruit;

  /// Shown when posting a review fails.
  ///
  /// In en, this message translates to:
  /// **'Could not send your review. Please try again.'**
  String get reviewSubmitFailed;

  /// Title of the shared camera screen.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get cameraCaptureTitle;

  /// Shutter button label.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get cameraCaptureAction;

  /// Hint on the pledge capture screen.
  ///
  /// In en, this message translates to:
  /// **'Frame the products you are recording'**
  String get pledgeCaptureHint;

  /// Hint on the review photo screen.
  ///
  /// In en, this message translates to:
  /// **'Take a photo to attach to your review'**
  String get reviewPhotoHint;

  /// Shown after removing a review photo.
  ///
  /// In en, this message translates to:
  /// **'Photo removed'**
  String get reviewPhotoRemoved;

  /// Hint on the product photo screen.
  ///
  /// In en, this message translates to:
  /// **'Photograph the product for the listing'**
  String get sellerProductImageHint;

  /// Shown after adding a product photo.
  ///
  /// In en, this message translates to:
  /// **'Photo added'**
  String get sellerProductImageAttached;

  /// Shown after scanning a voucher code.
  ///
  /// In en, this message translates to:
  /// **'Scanned a {format} code'**
  String manualVoucherCodeScanned(Object format);

  /// Copies the label details to the clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy label details'**
  String get qrLabelCopyAction;

  /// No description provided for @authPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Password reset'**
  String get authPasswordReset;

  /// No description provided for @authPasswordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get authPasswordChanged;

  /// Timeline entry title when the server sent none.
  ///
  /// In en, this message translates to:
  /// **'Freshness record'**
  String get pledgeHistoryDefaultTitle;

  /// Timeline entry subtitle built from the pledged score and category.
  ///
  /// In en, this message translates to:
  /// **'Score {score}/10 · {category}'**
  String pledgeHistoryScoreLine(Object score, Object category);

  /// Timeline subtitle when the pledge has a score but no category.
  ///
  /// In en, this message translates to:
  /// **'Score {score}/10'**
  String pledgeHistoryScoreOnly(Object score);

  /// Line of the copied QR label text.
  ///
  /// In en, this message translates to:
  /// **'Pledge ID: {pledgeId}'**
  String qrLabelClipboardPledge(Object pledgeId);

  /// Line of the copied QR label text.
  ///
  /// In en, this message translates to:
  /// **'Bundle ID: {bundleId}'**
  String qrLabelClipboardBundle(Object bundleId);

  /// Line of the copied QR label text.
  ///
  /// In en, this message translates to:
  /// **'Token: {token}'**
  String qrLabelClipboardToken(Object token);

  /// Author label when the server sends no reviewer name.
  ///
  /// In en, this message translates to:
  /// **'A shopper'**
  String get reviewAnonymousAuthor;

  /// Home tab empty and error states.
  ///
  /// In en, this message translates to:
  /// **'Could not load data'**
  String get homeLoadFailedTitle;

  /// Home tab empty and error states.
  ///
  /// In en, this message translates to:
  /// **'Check the connection to the server and try again.'**
  String get homeLoadFailedMessage;

  /// Home tab empty and error states.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get homeRetryAction;

  /// Home tab empty and error states.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get homeEmptyTitle;

  /// Home tab empty and error states.
  ///
  /// In en, this message translates to:
  /// **'Products appear here once sellers record their freshness.'**
  String get homeEmptyMessage;

  /// Location-aware home copy.
  ///
  /// In en, this message translates to:
  /// **'Turn on location'**
  String get homeLocationUnknown;

  /// Location-aware home copy.
  ///
  /// In en, this message translates to:
  /// **'Finding you…'**
  String get homeLocationSearching;

  /// Location-aware home copy.
  ///
  /// In en, this message translates to:
  /// **'Near you'**
  String get homeLocationNearby;

  /// Location-aware home copy.
  ///
  /// In en, this message translates to:
  /// **'Turn on location to see the shops closest to you first.'**
  String get homeLocationOffHint;

  /// Location-aware home copy.
  ///
  /// In en, this message translates to:
  /// **'Allow location for this app in Settings.'**
  String get homeLocationBlockedHint;

  /// Location-aware home copy.
  ///
  /// In en, this message translates to:
  /// **'No shops near you'**
  String get homeNoShopNearbyTitle;

  /// Location-aware home copy.
  ///
  /// In en, this message translates to:
  /// **'Nothing found within 20 km of where you are.'**
  String get homeNoShopNearbyMessage;

  /// Map location states.
  ///
  /// In en, this message translates to:
  /// **'Finding where you are'**
  String get mapLocatingTitle;

  /// Map location states.
  ///
  /// In en, this message translates to:
  /// **'The map will open right where you are standing.'**
  String get mapLocatingMessage;

  /// Map location states.
  ///
  /// In en, this message translates to:
  /// **'No location yet — showing the shops on file.'**
  String get mapLocationUnavailable;

  /// Shown when the nearest shops are past the search radius.
  ///
  /// In en, this message translates to:
  /// **'No shops within 20 km. These are the closest there are.'**
  String get homeOutsideRangeNotice;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Posted {when}'**
  String productDetailPostedAt(Object when);

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Sold by {shop}'**
  String productDetailSoldBy(Object shop);

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Change history'**
  String get productHistoryTitle;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Every change is signed and chained by hash, and cannot be rewritten'**
  String get productHistorySubtitle;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Chain intact'**
  String get productHistoryVerified;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Chain shows signs of tampering'**
  String get productHistoryBroken;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Copied {sha}'**
  String productHistoryCopied(Object sha);

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Product created'**
  String get productHistoryActionCreated;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get productHistoryActionUpdated;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Taken off the shelf'**
  String get productHistoryActionDeleted;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Moderated'**
  String get productHistoryActionModerated;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'No changes have been recorded yet.'**
  String get productHistoryEmpty;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Price over {days} days'**
  String productPriceChartTitle(Object days);

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'The price has not moved in {days} days.'**
  String productPriceChartFlat(Object days);

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get productFieldPrice;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get productFieldName;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productFieldDescription;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get productFieldCategory;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Freshness score'**
  String get productFieldFreshnessScore;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Freshness note'**
  String get productFieldFreshnessNote;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get productFieldStatus;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get productFieldTags;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get productFieldImages;

  /// Product detail history and price copy.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get productFieldCurrency;

  /// Recommendation section copy.
  ///
  /// In en, this message translates to:
  /// **'Suggested for you'**
  String get homeForYouTitle;

  /// Recommendation section copy.
  ///
  /// In en, this message translates to:
  /// **'Widely trusted'**
  String get homePopularTitle;

  /// Recommendation section copy.
  ///
  /// In en, this message translates to:
  /// **'From {count} things you have done'**
  String homeForYouBasis(Object count);

  /// Recommendation section copy.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded for you yet — these are the most trusted choices'**
  String get homePopularBasis;

  /// Recommendation section copy.
  ///
  /// In en, this message translates to:
  /// **'Matches the {category} you look at'**
  String recommendReasonCategory(Object category);

  /// Recommendation section copy.
  ///
  /// In en, this message translates to:
  /// **'A shop you reviewed'**
  String get recommendReasonShopRated;

  /// Recommendation section copy.
  ///
  /// In en, this message translates to:
  /// **'Near you'**
  String get recommendReasonNear;

  /// Recommendation section copy.
  ///
  /// In en, this message translates to:
  /// **'High trust score'**
  String get recommendReasonTrust;

  /// Recommendation section copy.
  ///
  /// In en, this message translates to:
  /// **'Well rated'**
  String get recommendReasonRated;

  /// Cross-shop price comparison copy.
  ///
  /// In en, this message translates to:
  /// **'Average price across shops'**
  String get marketPriceTitle;

  /// Cross-shop price comparison copy.
  ///
  /// In en, this message translates to:
  /// **'Averaged over {count} shops selling the same item'**
  String marketPriceBasis(Object count);

  /// Cross-shop price comparison copy.
  ///
  /// In en, this message translates to:
  /// **'{percent}% below average'**
  String marketPriceCheaper(Object percent);

  /// Cross-shop price comparison copy.
  ///
  /// In en, this message translates to:
  /// **'{percent}% above average'**
  String marketPriceDearer(Object percent);

  /// Cross-shop price comparison copy.
  ///
  /// In en, this message translates to:
  /// **'In line with the average'**
  String get marketPriceInline;

  /// Cross-shop price comparison copy.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get marketPriceAverageLabel;

  /// Cross-shop price comparison copy.
  ///
  /// In en, this message translates to:
  /// **'This shop'**
  String get marketPriceThisShopLabel;

  /// Cross-shop price comparison copy.
  ///
  /// In en, this message translates to:
  /// **'Lowest {low} · Highest {high}'**
  String marketPriceRange(Object low, Object high);

  /// No description provided for @sellerDashboardNoShopTitle.
  ///
  /// In en, this message translates to:
  /// **'This account has no shop yet'**
  String get sellerDashboardNoShopTitle;

  /// No description provided for @sellerDashboardNoShopBody.
  ///
  /// In en, this message translates to:
  /// **'Create a shop first, then you can add products and records.'**
  String get sellerDashboardNoShopBody;

  /// No description provided for @sellerDashboardNoShopAction.
  ///
  /// In en, this message translates to:
  /// **'Create a shop'**
  String get sellerDashboardNoShopAction;

  /// No description provided for @sellerDashboardFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load the shop figures'**
  String get sellerDashboardFailedTitle;

  /// No description provided for @sellerDashboardFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Check the connection and try again.'**
  String get sellerDashboardFailedBody;

  /// No description provided for @sellerShopSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the shop. Check the connection and try again.'**
  String get sellerShopSaveFailed;

  /// No description provided for @sellerShopLoadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load the shop details'**
  String get sellerShopLoadFailedTitle;

  /// No description provided for @sellerShopStateActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get sellerShopStateActive;

  /// No description provided for @sellerShopStateSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get sellerShopStateSuspended;

  /// No description provided for @sellerShopStateDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get sellerShopStateDeleted;

  /// No description provided for @sellerIntegrityLabel.
  ///
  /// In en, this message translates to:
  /// **'Integrity'**
  String get sellerIntegrityLabel;
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
