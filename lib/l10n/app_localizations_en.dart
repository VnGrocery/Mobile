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
      'Sign in to check products, view maps and compare store prices.';

  @override
  String get authRegisterInfo =>
      'Create an account to check products and keep your reviews.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authDisplayNameLabel => 'Display name';

  @override
  String get validationEmailRequired => 'Enter email';

  @override
  String get validationEmailInvalid => 'Invalid email';

  @override
  String get validationDisplayNameTooShort =>
      'Enter a display name with at least 2 characters';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 8 characters';

  @override
  String get validationPasswordRequired => 'Enter password';

  @override
  String get validationNewPasswordTooShort =>
      'New password must be at least 8 characters';

  @override
  String get validationCurrentPasswordRequired => 'Enter current password';

  @override
  String get validationCurrentPasswordLabel => 'Current password';

  @override
  String get validationPasswordMustDiffer =>
      'New password must be different from current password';

  @override
  String get validationConfirmPasswordMismatch => 'Passwords do not match';

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
      'Enter your account email to get a reset code.';

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
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get authChangePassword => 'Change password';

  @override
  String get authPasswordSecurityTitle => 'Account security';

  @override
  String get authPasswordRuleTitle => 'Password requirements';

  @override
  String get authPasswordRuleMinLength => 'At least 8 characters';

  @override
  String get authPasswordRuleComplexity =>
      'Should include uppercase letters, numbers, and special characters';

  @override
  String get authPasswordRuleDifferentFromCurrent =>
      'Do not reuse your current password';

  @override
  String get authPasswordStrengthWeakHint => 'New password is still weak';

  @override
  String get authPasswordStrengthMediumHint => 'New password is moderate';

  @override
  String get authPasswordStrengthStrongHint => 'New password is strong';

  @override
  String get authPasswordUpdateSaving => 'Updating...';

  @override
  String get authPasswordUpdateSubmit => 'Update password';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonClose => 'Close';

  @override
  String get commonDate => 'Date';

  @override
  String get commonDecreaseQuantity => 'Decrease quantity';

  @override
  String get cartTitle => 'Checkout cart';

  @override
  String get cartClearTooltip => 'Clear cart';

  @override
  String get cartEmptyBody =>
      'Your cart is empty.\nAdd products to estimate totals and check vouchers.';

  @override
  String get cartExpiryNotice =>
      'Items in the cart are kept for 24 hours for pricing and voucher checks.';

  @override
  String get cartGrandSubtotal => 'Grand subtotal';

  @override
  String get cartGrandDiscount => 'Total voucher discount';

  @override
  String get cartGrandTotal => 'Estimated grand total';

  @override
  String get cartUnavailableShopName => 'Store unavailable';

  @override
  String cartAppliedVoucher(Object code) {
    return 'Applied: $code';
  }

  @override
  String get cartRemoveVoucher => 'Remove code';

  @override
  String get cartVoucherFieldLabel => 'Store voucher code';

  @override
  String get cartCheckVoucher => 'Check';

  @override
  String get cartShopSubtotal => 'Subtotal';

  @override
  String get cartShopDiscount => 'Voucher discount';

  @override
  String get cartShopTotal => 'Remaining';

  @override
  String get cartBadgeTooltip => 'Cart';

  @override
  String get buyerCheckResultTitle => 'Check result';

  @override
  String get buyerCheckViewStore => 'View store';

  @override
  String get buyerCheckRetake => 'Retake';

  @override
  String get buyerCheckVoucherSaved => 'Voucher saved to wallet';

  @override
  String get buyerCheckLocationNear => 'Recorded at the counter';

  @override
  String get buyerCheckLocationNeedsMore => 'More confirmations needed';

  @override
  String get buyerCheckLocationNearBody =>
      'You are near the store. This check is counted in recent store data.';

  @override
  String get buyerCheckLocationNeedsMoreBody =>
      'You are not near the store. This check is for reference only.';

  @override
  String get buyerCheckVerdictTitle => 'Compared with the latest data';

  @override
  String buyerCheckVerdictValue(Object verdict) {
    return 'Result: $verdict';
  }

  @override
  String get buyerCheckVerdictBody =>
      'This result is based on the photo you submitted and the recorded information.';

  @override
  String get buyerCheckVoucherTitle => 'Check voucher';

  @override
  String get buyerCheckVoucherCodeHint => 'E.g. FRESH20';

  @override
  String get buyerCheckVoucherDiscount => 'Discount';

  @override
  String get buyerCheckVoucherRemaining => 'Remaining';

  @override
  String get buyerCheckOpenWallet => 'Open wallet';

  @override
  String get exploreTitle => 'Explore stores';

  @override
  String get exploreStoreTitle => 'Stores';

  @override
  String get exploreNearbyStoresTitle => 'Stores near you';

  @override
  String get exploreAllStoresTitle => 'All stores';

  @override
  String get exploreNoResults => 'No matching stores found';

  @override
  String get exploreSearchHint => 'Search by store name or address...';

  @override
  String get exploreDirections => 'Directions';

  @override
  String get exploreYourLocation => 'Your location';

  @override
  String get exploreOpenMap => 'Open map';

  @override
  String get exploreTopRatedBadge => 'Top rated';

  @override
  String exploreRatingLabel(Object rating) {
    return ' $rating rating points';
  }

  @override
  String get exploreFilterTopRated => 'Top rated';

  @override
  String get exploreFilterRecorded => 'Recorded';

  @override
  String get exploreFilterNearby => 'Near you';

  @override
  String get exploreFilterNewest => 'Newest';

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
  String get sellerShopSaved => 'Store details saved';

  @override
  String get sellerShopNameLabel => 'Store name';

  @override
  String get sellerShopDescriptionLabel => 'Description';

  @override
  String get sellerShopAddressLabel => 'Address';

  @override
  String get sellerShopFootnote =>
      'This information is shown on the store page and product labels.';

  @override
  String get sellerShopNotRatedYet => 'Not rated yet';

  @override
  String sellerShopGradeSummary(Object grade, Object rating) {
    return 'Grade $grade - $rating points';
  }

  @override
  String get sellerShopPledgesMetric => 'Pledges';

  @override
  String get sellerShopWarningsMetric => 'Warnings';

  @override
  String get sellerProductNoShop => 'Your account does not have a store yet.';

  @override
  String get sellerProductCreateTitle => 'Add new product';

  @override
  String get sellerProductSaved => 'Product published';

  @override
  String get sellerProductSaveFailed =>
      'Could not save the product. Check the connection and try again.';

  @override
  String get sellerProductImageUploadFailed =>
      'The photo could not be uploaded. The product was saved without it.';

  @override
  String get sellerProductImageRemoved => 'Product image removed';

  @override
  String get sellerProductStateAll => 'All';

  @override
  String get sellerProductStatePublished => 'Published';

  @override
  String get sellerProductStateDraft => 'Draft';

  @override
  String get sellerProductStateArchived => 'Archived';

  @override
  String get sellerCategoryBeef => 'Beef';

  @override
  String get sellerCategoryPork => 'Pork';

  @override
  String get sellerCategoryChicken => 'Chicken';

  @override
  String get sellerCategorySeafood => 'Seafood';

  @override
  String get sellerCategoryPoultry => 'Poultry';

  @override
  String get sellerCategoryOther => 'Other';

  @override
  String get sellerProductFreshnessWithImage => 'New product, photo attached.';

  @override
  String get sellerProductFreshnessWithoutImage => 'Newly created product.';

  @override
  String get sellerProductImageTitle => 'Product image';

  @override
  String get sellerProductImageReady => 'Photo attached';

  @override
  String get sellerProductImageSelect => 'Take a product photo';

  @override
  String get sellerProductNameLabel => 'Product name';

  @override
  String get sellerProductPriceLabel => 'Price';

  @override
  String get sellerProductCategoryLabel => 'Category';

  @override
  String get sellerProductDescriptionLabel => 'Description';

  @override
  String get sellerProductTagsLabel => 'Tags';

  @override
  String get sellerProductTagsHint => 'E.g. fresh, clean, organic';

  @override
  String get sellerProductSave => 'Save product';

  @override
  String get sellerProductActionViewDetail => 'View details';

  @override
  String get sellerProductActionViewHistory => 'View history';

  @override
  String get sellerProductActionAddPledge => 'Add pledge';

  @override
  String get sellerProductEmpty => 'No products yet';

  @override
  String sellerProductCategoryValue(Object category) {
    return 'Category: $category';
  }

  @override
  String get sellerProductHistoryShort => 'History';

  @override
  String get sellerProductAddPledgeShort => 'Add pledge';

  @override
  String get sellerPledgeCategoryBeef => 'Beef';

  @override
  String get sellerPledgeCategoryPork => 'Pork';

  @override
  String get sellerPledgeCategoryChicken => 'Chicken';

  @override
  String get sellerPledgeCategorySeafood => 'Seafood';

  @override
  String get sellerPledgeCategoryOther => 'Other';

  @override
  String get sellerPledgeStepCapture => 'Step 1: Capture product photo';

  @override
  String get sellerPledgeStepEvaluate => 'Step 2: Evaluate product';

  @override
  String get sellerPledgeStepConfirm => 'Step 3: Confirm pledge';

  @override
  String get sellerPledgeRecordTimeJustNow => 'Just now';

  @override
  String get sellerPledgeRecordTitle => 'Seller added a new pledge';

  @override
  String sellerPledgeRecordDescription(Object score, Object category) {
    return 'Score $score/10 for category: $category.';
  }

  @override
  String get sellerPledgeCaptureInvalidImage =>
      'That photo could not be used. Take a clearer one.';

  @override
  String get sellerPledgeCaptureUnavailable =>
      'The scoring service is unavailable. Try again in a few minutes.';

  @override
  String get sellerPledgeCaptureFailed =>
      'The photo could not be scored. Check the connection and try again.';

  @override
  String get sellerPledgeCaptureAction => 'Capture product photo';

  @override
  String get sellerPledgeSuggestedScoreTitle => 'SUGGESTED SCORE FROM IMAGE';

  @override
  String get sellerPledgeSellerScoreTitle => 'SELLER SCORE';

  @override
  String get sellerPledgeScoreRange => 'A score from 0 to 10';

  @override
  String get sellerPledgeSaveFailed =>
      'Could not save the record. Check the connection and try again.';

  @override
  String get sellerPledgeSellerScoreLabel => 'Enter score (0-10)';

  @override
  String get sellerPledgeContinueConfirm => 'Continue to confirm';

  @override
  String sellerPledgeCategoryValue(Object category) {
    return 'Category: $category';
  }

  @override
  String get sellerPledgeRecordContentTitle => 'PLEDGE CONTENT';

  @override
  String sellerPledgeRecordPreview(Object score) {
    return 'I recorded this product at the counter with a score of $score.';
  }

  @override
  String get sellerPledgeConfirmSave => 'Confirm & save pledge';

  @override
  String get sellerPledgeSaved => 'Product pledge saved.';

  @override
  String get accountExploreStores => 'Explore stores';

  @override
  String get accountScanProducts => 'Scan products';

  @override
  String get scannerFrameHint =>
      'Place the QR code or product tag inside the frame';

  @override
  String get scannerCheckingAction => 'Checking...';

  @override
  String get scannerSimulateAction => 'Capture & analyze with AI';

  @override
  String get scannerStatusVerifying => 'Checking counter location...';

  @override
  String get scannerStatusReady => 'Ready to verify product';

  @override
  String get scannerOverlayVerifying => 'Checking product...';

  @override
  String get accountDarkMode => 'Dark mode';

  @override
  String get accountEditProfile => 'Edit profile';

  @override
  String get accountHelpAndSupport => 'Help & support';

  @override
  String get accountSaveProfileChanges => 'Save changes';

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
  String get commonBuyer => 'Buyer';

  @override
  String get commonSeller => 'Seller';

  @override
  String get accountSellerModeBody =>
      'Seller mode: manage store, products, and pledges.';

  @override
  String get accountBuyerModeBody =>
      'Buyer mode: explore, scan codes, and check products.';

  @override
  String get homeGreeting => 'Hello,';

  @override
  String get homeLocationDistrict1 => 'District 1';

  @override
  String get homeSearchHint => 'Search stores, products...';

  @override
  String get homeScanHeroBody => 'Check against recorded data';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeCategoriesTitle => 'Categories';

  @override
  String get homeCategoryPork => 'Pork';

  @override
  String get homeCategoryBeef => 'Beef';

  @override
  String get homeCategoryPoultry => 'Poultry';

  @override
  String get homeCategorySeafood => 'Seafood';

  @override
  String get homeTopRatedStoresTitle => 'Top-rated stores';

  @override
  String get homeRecentChecksTitle => 'Recently checked products';

  @override
  String homeShopRatingValue(Object rating) {
    return ' $rating';
  }

  @override
  String homeShopReviewCount(Object count) {
    return '$count reviews';
  }

  @override
  String get aiFreshnessTitle => 'Submit check photo';

  @override
  String get aiFreshnessHeading => 'Take a product photo at the counter';

  @override
  String get aiFreshnessBody =>
      'This photo helps compare with recently recorded information.';

  @override
  String get aiFreshnessAnalyzing => 'Comparing with latest data...';

  @override
  String get aiFreshnessAction => 'Take photo & check';

  @override
  String get pledgeOverviewTitle => 'Seller overview';

  @override
  String get pledgeOverviewMetricsTitle => 'Store metrics';

  @override
  String get pledgeOverviewHint =>
      'Shoot in good light so the score is stable. Each record is anchored on the blockchain.';

  @override
  String get voucherWalletTitle => 'Voucher wallet';

  @override
  String get voucherWalletAddManualTooltip => 'Add manually';

  @override
  String get qrLabelTitle => 'Product QR code';

  @override
  String get qrLabelCopied => 'QR label content copied';

  @override
  String get splashSubtitle => 'Check prices and products near you';

  @override
  String get splashFootnote => 'Data from store counters and the community';

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
  String storeShareSummary(Object rating, Object reviewCount) {
    return '$rating rating points - $reviewCount reviews';
  }

  @override
  String storeProductShopLabel(Object shopId) {
    return 'Store: $shopId';
  }

  @override
  String storeProductScore(Object score) {
    return '$score points';
  }

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
  String get reviewTitle => 'Store review';

  @override
  String get reviewIntroTitle => 'How was your experience?';

  @override
  String get reviewIntroBody =>
      'Your review helps the community choose better products.';

  @override
  String get reviewCommentHint => 'Enter your comments here...';

  @override
  String get reviewPhotoAttached => 'Photo attached';

  @override
  String get reviewPhotoAdd => 'Add image';

  @override
  String get reviewSubmit => 'Submit review';

  @override
  String get reviewSubmitted => 'Review submitted. Thank you!';

  @override
  String get reviewSubmittedWithPhoto =>
      'Review with photo submitted. Thank you!';

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

  @override
  String get trustProofVerifiedLabel => 'Verified on blockchain';

  @override
  String get trustProofPendingLabel => 'Anchoring to blockchain';

  @override
  String get trustProofWarningLabel => 'Mismatch detected';

  @override
  String get trustProofRevokedLabel => 'Pledge revoked';

  @override
  String get trustProofUnknownLabel => 'Not verified yet';

  @override
  String get trustProofVerifiedSummary =>
      'The freshness pledge was anchored on the blockchain and still matches.';

  @override
  String get trustProofPendingSummary =>
      'The pledge was created but has not finished anchoring yet.';

  @override
  String get trustProofWarningSummary =>
      'The stored data no longer matches the record on the blockchain.';

  @override
  String get trustProofRevokedSummary =>
      'This pledge was withdrawn and should no longer be trusted.';

  @override
  String get trustProofUnknownSummary =>
      'The blockchain record for this pledge could not be checked.';

  @override
  String get trustGradeExcellent => 'Excellent';

  @override
  String get trustGradeGood => 'Good';

  @override
  String get trustGradeWatch => 'Needs watching';

  @override
  String get trustGradeRisk => 'Risky';

  @override
  String get trustScoreTitle => 'Trust score';

  @override
  String get trustScoreNoData => 'Not enough data to rate this shop yet.';

  @override
  String get trustScoreBreakdown => 'How this score is made up';

  @override
  String get trustScoreReasons => 'Why';

  @override
  String trustScoreFormula(Object version) {
    return 'Formula $version';
  }

  @override
  String get trustComponentPledge => 'Seller pledges';

  @override
  String get trustComponentReview => 'Customer reviews';

  @override
  String get trustComponentBuyerCheck => 'Buyer checks';

  @override
  String get trustComponentConsistency => 'Consistency';

  @override
  String get trustComponentRecency => 'Recent activity';

  @override
  String get trustComponentCoverage => 'Signal coverage';

  @override
  String get trustReasonPartialTrustData =>
      'Only part of the trust data is available';

  @override
  String get trustReasonNoCustomerReviews => 'No customer reviews yet';

  @override
  String get trustReasonNoBuyerChecks => 'No buyer has verified a product yet';

  @override
  String get trustReasonNoEligibleBuyerChecks =>
      'No buyer check counted towards the score';

  @override
  String get trustReasonBuyerChecksConfirmed =>
      'Buyer checks confirmed the seller pledges';

  @override
  String get trustReasonBuyerChecksHighRisk =>
      'Buyer checks flagged a high risk';

  @override
  String get trustReasonBuyerChecksConsistencyIssues =>
      'Buyer checks disagree with the pledges';

  @override
  String get trustReasonDuplicateBuyerChecks =>
      'Duplicate buyer checks were discounted';

  @override
  String get trustReasonPledgesConsistent =>
      'Pledges are consistent with buyer checks';

  @override
  String get trustReasonLimitedConsistencyData =>
      'Not enough data to judge consistency';

  @override
  String get trustReasonNoConsistencySignals =>
      'No consistency signals available';

  @override
  String get trustReasonLimitedSignalCoverage =>
      'Trust signals cover only a few products';

  @override
  String get trustReasonRecentActivity => 'The shop has been active recently';

  @override
  String get trustReasonNoRecentActivity => 'No recent activity from this shop';

  @override
  String get trustReasonNoPledge => 'This product has no freshness pledge';

  @override
  String get trustReasonNoSellerPledges =>
      'The seller has not made any pledge yet';

  @override
  String get trustReasonSomePledgesLowConfidence =>
      'Some pledges have low confidence';

  @override
  String get blockchainProofTitle => 'Blockchain certificate';

  @override
  String get blockchainProofPledge => 'Pledge';

  @override
  String get blockchainProofTxHash => 'Transaction';

  @override
  String get blockchainProofBlock => 'Block';

  @override
  String get blockchainProofDataHash => 'Data hash';

  @override
  String get blockchainProofAnchoredAt => 'Anchored at';

  @override
  String get blockchainProofMatch => 'Hash matches the chain';

  @override
  String get blockchainProofYes => 'Yes';

  @override
  String get blockchainProofNo => 'No';

  @override
  String get blockchainProofNoRecord =>
      'This pledge has no record on the blockchain yet.';

  @override
  String get blockchainProofRefresh => 'Refresh';

  @override
  String get blockchainProofCopied => 'Copied';

  @override
  String get blockchainProofCopyHint => 'Tap a value to copy it';

  @override
  String get blockchainProofScore => 'Pledged freshness';

  @override
  String get buyerCheckCompareTitle => 'Pledge vs. what we measured';

  @override
  String get buyerCheckPledged => 'Seller pledged';

  @override
  String get buyerCheckMeasured => 'Measured now';

  @override
  String get buyerCheckDelta => 'Difference';

  @override
  String get buyerCheckCategoryMatch => 'Product type matches';

  @override
  String get buyerCheckNoPledge =>
      'This product has no pledge to compare against.';

  @override
  String get buyerCheckTrusted => 'Consistent with the pledge';

  @override
  String get buyerCheckNotTrusted => 'Does not match the pledge';

  @override
  String buyerCheckConfidence(Object percent) {
    return 'AI confidence $percent%';
  }

  @override
  String get qrScanTitle => 'Scan bundle code';

  @override
  String get qrScanHint => 'Point the camera at the code on the label';

  @override
  String get qrScanNotOurCode => 'This is not a VnGrocery code';

  @override
  String get qrScanExpired =>
      'This code has expired, ask the seller for a new label';

  @override
  String get qrScanUnsupported => 'This code needs a newer app version';

  @override
  String get qrScanCameraError => 'Cannot open the camera';

  @override
  String get qrScanChecking => 'Checking...';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navScanProducts => 'Scan';

  @override
  String get navStores => 'Stores';

  @override
  String get navVoucherWallet => 'Vouchers';

  @override
  String get navAccount => 'Account';

  @override
  String get navSellerOverview => 'Overview';

  @override
  String get navSellerProducts => 'Products';

  @override
  String get navSellerStore => 'My store';

  @override
  String get onboardingTitle1 => 'See the data behind a product';

  @override
  String get onboardingBody1 =>
      'Every product carries a freshness score and a clear record of its history.';

  @override
  String get onboardingTitle2 => 'Check it with a photo';

  @override
  String get onboardingBody2 =>
      'Scan the label or take a photo at the counter to compare with the latest record.';

  @override
  String get onboardingTitle3 => 'Decide with confidence';

  @override
  String get onboardingBody3 =>
      'Comparing is easier when the information comes from real recorded checks.';

  @override
  String get sellerShopStatusTitle => 'Store status';

  @override
  String get sellerStatusLabel => 'Status';

  @override
  String get sellerTotalRecords => 'Total records';

  @override
  String get sellerLatestReceipt => 'Latest receipt';

  @override
  String get sellerNone => 'None yet';

  @override
  String get sellerNeedsReview => 'Needs review';

  @override
  String get sellerStable => 'Stable';

  @override
  String get sellerAddRecordTitle => 'Record a product';

  @override
  String get sellerAddRecordBody =>
      'Pick a product and save its details at the counter.';

  @override
  String get sellerNeedProductFirst => 'Create a product before recording.';

  @override
  String get sellerProductsLabel => 'Products';

  @override
  String get sellerHistoryLabel => 'History';

  @override
  String get sellerTrustLabel => 'Trust';

  @override
  String get sellerRecordsToday => 'Records today';

  @override
  String get sellerBuyerAlerts => 'Buyer alerts';

  @override
  String voucherDiscountPercent(Object value) {
    return 'Save $value%';
  }

  @override
  String voucherDiscountAmount(Object amount) {
    return 'Save $amount';
  }

  @override
  String get voucherManualInfo => 'Manually entered';

  @override
  String voucherMinSpendFrom(Object amount) {
    return 'From $amount';
  }

  @override
  String get voucherExpiredLabel => 'Expired';

  @override
  String get voucherUsableLabel => 'Usable';

  @override
  String get voucherReadyLabel => 'Ready to use';

  @override
  String get voucherPerYourInput => 'Based on what you entered';

  @override
  String get qrLabelReadyTitle => 'Your QR code is ready';

  @override
  String get qrLabelReadyBody => 'Print it and stick it on the packaging.';

  @override
  String qrLabelRecordId(Object id) {
    return 'Record: $id';
  }

  @override
  String get qrLabelScanHint => 'Scan to check this product';

  @override
  String get qrLabelBackHome => 'Back to home';

  @override
  String get homeAddToCart => 'Add to cart';

  @override
  String homeAddedToCart(Object name) {
    return 'Added $name';
  }

  @override
  String get homeRecentChecks => 'Recently checked products';

  @override
  String get pledgeTimelineTitle => 'Product timeline';

  @override
  String historyShowMore(Object count) {
    return 'Show $count more';
  }

  @override
  String get historyShowLess => 'Show less';

  @override
  String get pledgeHistoryEmpty => 'No records yet';

  @override
  String pledgeOriginalReceipt(Object id) {
    return 'Original receipt: $id';
  }

  @override
  String get scannerNoCamera => 'No camera found';

  @override
  String get scannerOpeningCamera => 'Opening the camera...';

  @override
  String scannerConfidence(Object percent) {
    return 'Confidence: $percent%';
  }

  @override
  String get voucherUsedShort => 'Used';

  @override
  String get navScanShort => 'Scan';

  @override
  String get sideMenuFootnote => 'Data from counters and the community';

  @override
  String get roleSeller => 'Seller';

  @override
  String get roleBuyer => 'Buyer';

  @override
  String get voucherBarcode => 'Barcode';

  @override
  String get exploreNearbyTitle => 'Stores near you';

  @override
  String get exploreViewStore => 'View store';

  @override
  String get exploreSearchNearby => 'Find stores near you';

  @override
  String get buyerCheckScanFirst =>
      'Scan a valid pledge label before checking.';

  @override
  String get authErrorInvalidCredentials => 'Wrong email or password';

  @override
  String get authErrorAccountDeleted => 'This account has been disabled';

  @override
  String get authErrorEmailTaken => 'That email is already registered';

  @override
  String get authErrorInvalidInput =>
      'Check the email and password. Passwords need at least 8 characters.';

  @override
  String get authErrorNetwork =>
      'Could not reach the server. Check the connection and try again.';

  @override
  String get authErrorGeneric => 'Sign in failed. Please try again.';

  @override
  String get authGoogleTokenError => 'Could not get a Google ID token';

  @override
  String get pledgeHistoryTitle => 'Record history';

  @override
  String get scoreLabel => 'Score';

  @override
  String qrLabelClipboard(Object pledgeId) {
    return 'VnGrocery Check\nRecord: $pledgeId\nScan the code to check this product';
  }

  @override
  String get sellerModeSubtitle => 'Seller mode';

  @override
  String scannerConfidenceValue(Object percent) {
    return 'Confidence: $percent%';
  }

  @override
  String get homeCategoryFreshProduce => 'Fresh produce';

  @override
  String get homeCategoryMeat => 'Meat';

  @override
  String get homeCategoryVegetables => 'Vegetables';

  @override
  String get homeCategoryFruit => 'Fruit';

  @override
  String get reviewSubmitFailed =>
      'Could not send your review. Please try again.';

  @override
  String get cameraCaptureTitle => 'Take a photo';

  @override
  String get cameraCaptureAction => 'Capture';

  @override
  String get pledgeCaptureHint => 'Frame the products you are recording';

  @override
  String get reviewPhotoHint => 'Take a photo to attach to your review';

  @override
  String get reviewPhotoRemoved => 'Photo removed';

  @override
  String get sellerProductImageHint => 'Photograph the product for the listing';

  @override
  String get sellerProductImageAttached => 'Photo added';

  @override
  String manualVoucherCodeScanned(Object format) {
    return 'Scanned a $format code';
  }

  @override
  String get qrLabelCopyAction => 'Copy label details';

  @override
  String get authPasswordReset => 'Password reset';

  @override
  String get authPasswordChanged => 'Password changed';

  @override
  String get pledgeHistoryDefaultTitle => 'Freshness record';

  @override
  String pledgeHistoryScoreLine(Object score, Object category) {
    return 'Score $score/10 · $category';
  }

  @override
  String pledgeHistoryScoreOnly(Object score) {
    return 'Score $score/10';
  }

  @override
  String qrLabelClipboardPledge(Object pledgeId) {
    return 'Pledge ID: $pledgeId';
  }

  @override
  String qrLabelClipboardBundle(Object bundleId) {
    return 'Bundle ID: $bundleId';
  }

  @override
  String qrLabelClipboardToken(Object token) {
    return 'Token: $token';
  }

  @override
  String get reviewAnonymousAuthor => 'A shopper';

  @override
  String get homeLoadFailedTitle => 'Could not load data';

  @override
  String get homeLoadFailedMessage =>
      'Check the connection to the server and try again.';

  @override
  String get homeRetryAction => 'Try again';

  @override
  String get homeEmptyTitle => 'No products yet';

  @override
  String get homeEmptyMessage =>
      'Products appear here once sellers record their freshness.';

  @override
  String get homeLocationUnknown => 'Turn on location';

  @override
  String get homeLocationSearching => 'Finding you…';

  @override
  String get homeLocationNearby => 'Near you';

  @override
  String get homeLocationOffHint =>
      'Turn on location to see the shops closest to you first.';

  @override
  String get homeLocationBlockedHint =>
      'Allow location for this app in Settings.';

  @override
  String get homeNoShopNearbyTitle => 'No shops near you';

  @override
  String get homeNoShopNearbyMessage =>
      'Nothing found within 20 km of where you are.';

  @override
  String get mapLocatingTitle => 'Finding where you are';

  @override
  String get mapLocatingMessage =>
      'The map will open right where you are standing.';

  @override
  String get mapLocationUnavailable =>
      'No location yet — showing the shops on file.';

  @override
  String get homeOutsideRangeNotice =>
      'No shops within 20 km. These are the closest there are.';

  @override
  String productDetailPostedAt(Object when) {
    return 'Posted $when';
  }

  @override
  String productDetailSoldBy(Object shop) {
    return 'Sold by $shop';
  }

  @override
  String get productHistoryTitle => 'Change history';

  @override
  String get productHistorySubtitle =>
      'Every change is signed and chained by hash, and cannot be rewritten';

  @override
  String get productHistoryVerified => 'Chain intact';

  @override
  String get productHistoryBroken => 'Chain shows signs of tampering';

  @override
  String productHistoryCopied(Object sha) {
    return 'Copied $sha';
  }

  @override
  String get productHistoryActionCreated => 'Product created';

  @override
  String get productHistoryActionUpdated => 'Updated';

  @override
  String get productHistoryActionDeleted => 'Taken off the shelf';

  @override
  String get productHistoryActionModerated => 'Moderated';

  @override
  String get productHistoryEmpty => 'No changes have been recorded yet.';

  @override
  String productPriceChartTitle(Object days) {
    return 'Price over $days days';
  }

  @override
  String productPriceChartFlat(Object days) {
    return 'The price has not moved in $days days.';
  }

  @override
  String get productFieldPrice => 'Price';

  @override
  String get productFieldName => 'Name';

  @override
  String get productFieldDescription => 'Description';

  @override
  String get productFieldCategory => 'Category';

  @override
  String get productFieldFreshnessScore => 'Freshness score';

  @override
  String get productFieldFreshnessNote => 'Freshness note';

  @override
  String get productFieldStatus => 'Status';

  @override
  String get productFieldTags => 'Tags';

  @override
  String get productFieldImages => 'Images';

  @override
  String get productFieldCurrency => 'Currency';

  @override
  String get homeForYouTitle => 'Suggested for you';

  @override
  String get homePopularTitle => 'Widely trusted';

  @override
  String homeForYouBasis(Object count) {
    return 'From $count things you have done';
  }

  @override
  String get homePopularBasis =>
      'Nothing recorded for you yet — these are the most trusted choices';

  @override
  String recommendReasonCategory(Object category) {
    return 'Matches the $category you look at';
  }

  @override
  String get recommendReasonShopRated => 'A shop you reviewed';

  @override
  String get recommendReasonNear => 'Near you';

  @override
  String get recommendReasonTrust => 'High trust score';

  @override
  String get recommendReasonRated => 'Well rated';

  @override
  String get marketPriceTitle => 'Average price across shops';

  @override
  String marketPriceBasis(Object count) {
    return 'Averaged over $count shops selling the same item';
  }

  @override
  String marketPriceCheaper(Object percent) {
    return '$percent% below average';
  }

  @override
  String marketPriceDearer(Object percent) {
    return '$percent% above average';
  }

  @override
  String get marketPriceInline => 'In line with the average';

  @override
  String get marketPriceAverageLabel => 'Average';

  @override
  String get marketPriceThisShopLabel => 'This shop';

  @override
  String marketPriceRange(Object low, Object high) {
    return 'Lowest $low · Highest $high';
  }

  @override
  String get sellerDashboardNoShopTitle => 'This account has no shop yet';

  @override
  String get sellerDashboardNoShopBody =>
      'Create a shop first, then you can add products and records.';

  @override
  String get sellerDashboardNoShopAction => 'Create a shop';

  @override
  String get sellerDashboardFailedTitle => 'Could not load the shop figures';

  @override
  String get sellerDashboardFailedBody => 'Check the connection and try again.';

  @override
  String get sellerShopSaveFailed =>
      'Could not save the shop. Check the connection and try again.';

  @override
  String get sellerShopLoadFailedTitle => 'Could not load the shop details';

  @override
  String get sellerShopStateActive => 'Active';

  @override
  String get sellerShopStateSuspended => 'Suspended';

  @override
  String get sellerShopStateDeleted => 'Deleted';

  @override
  String get sellerIntegrityLabel => 'Integrity';
}
