// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'VnGrocery';

  @override
  String get authLoginTab => 'Đăng nhập';

  @override
  String get authRegisterTab => 'Đăng ký';

  @override
  String get authCreateAccount => 'Tạo tài khoản';

  @override
  String get authSignIn => 'Đăng nhập';

  @override
  String get authContinueWithGoogle => 'Tiếp tục với Google';

  @override
  String get authWelcomeBack => 'Chào mừng bạn quay lại';

  @override
  String get authRegisterSubtitle => 'Tạo tài khoản để lưu kiểm chứng sản phẩm';

  @override
  String get authLoginInfo =>
      'Đăng nhập demo để kiểm tra sản phẩm, xem bản đồ và giá tại cửa hàng.';

  @override
  String get authRegisterInfo =>
      'Tài khoản demo sẽ dùng dữ liệu ảo cho đến khi gắn API thật.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Mật khẩu';

  @override
  String get authConfirmPasswordLabel => 'Nhập lại mật khẩu';

  @override
  String get authDisplayNameLabel => 'Tên hiển thị';

  @override
  String get validationEmailRequired => 'Nhập email';

  @override
  String get validationEmailInvalid => 'Email không hợp lệ';

  @override
  String get validationDisplayNameTooShort =>
      'Nhập tên hiển thị tối thiểu 2 ký tự';

  @override
  String get validationPasswordTooShort => 'Mật khẩu tối thiểu 8 ký tự';

  @override
  String get validationPasswordRequired => 'Nhập mật khẩu';

  @override
  String get validationNewPasswordTooShort => 'Mật khẩu mới tối thiểu 8 ký tự';

  @override
  String get validationCurrentPasswordRequired => 'Nhập mật khẩu hiện tại';

  @override
  String get validationCurrentPasswordLabel => 'Mật khẩu hiện tại';

  @override
  String get validationPasswordMustDiffer =>
      'Mật khẩu mới phải khác mật khẩu hiện tại';

  @override
  String get validationConfirmPasswordMismatch => 'Mật khẩu nhập lại chưa khớp';

  @override
  String get authForgotPassword => 'Quên mật khẩu?';

  @override
  String get authPasswordStrength => 'Độ mạnh mật khẩu';

  @override
  String get authPasswordStrong => 'Mạnh';

  @override
  String get authPasswordMedium => 'Khá';

  @override
  String get authPasswordWeak => 'Yếu';

  @override
  String get authForgotPasswordTitle => 'Quên mật khẩu';

  @override
  String get authResetPasswordTitle => 'Đặt lại mật khẩu';

  @override
  String get authForgotPasswordSubtitle =>
      'Nhập email tài khoản để xác minh demo.';

  @override
  String get authResetPasswordSubtitle =>
      'Tạo mật khẩu mới để tiếp tục đăng nhập.';

  @override
  String get authNewPasswordLabel => 'Mật khẩu mới';

  @override
  String get authConfirmNewPasswordLabel => 'Nhập lại mật khẩu mới';

  @override
  String get authContinue => 'Tiếp tục';

  @override
  String get authChangePassword => 'Đổi mật khẩu';

  @override
  String get authPasswordResetDemo => 'Đã đặt lại mật khẩu demo';

  @override
  String get authPasswordChangedDemo => 'Đã đổi mật khẩu demo thành công';

  @override
  String get authPasswordSecurityTitle => 'Bảo mật tài khoản';

  @override
  String get authPasswordRuleTitle => 'Yêu cầu mật khẩu';

  @override
  String get authPasswordRuleMinLength => 'Tối thiểu 8 ký tự';

  @override
  String get authPasswordRuleComplexity =>
      'Nên có chữ hoa, số và ký tự đặc biệt';

  @override
  String get authPasswordRuleDifferentFromCurrent =>
      'Không dùng lại mật khẩu hiện tại';

  @override
  String get authPasswordStrengthWeakHint => 'Mật khẩu mới còn yếu';

  @override
  String get authPasswordStrengthMediumHint => 'Mật khẩu mới ở mức khá';

  @override
  String get authPasswordStrengthStrongHint => 'Mật khẩu mới mạnh';

  @override
  String get authPasswordUpdateSaving => 'Đang cập nhật...';

  @override
  String get authPasswordUpdateSubmit => 'Cập nhật mật khẩu';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonConfirm => 'Xác nhận';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonClose => 'Đóng';

  @override
  String get commonDate => 'Ngày';

  @override
  String get commonDecreaseQuantity => 'Giảm số lượng';

  @override
  String get cartTitle => 'Giỏ tính tiền';

  @override
  String get cartClearTooltip => 'Xóa giỏ';

  @override
  String get cartEmptyBody =>
      'Giỏ đang trống.\nThêm sản phẩm để tính tiền và kiểm tra voucher.';

  @override
  String get cartExpiryNotice =>
      'Sản phẩm trong giỏ chỉ được giữ 24 giờ để tính tiền và kiểm tra voucher.';

  @override
  String get cartGrandSubtotal => 'Tổng tạm tính';

  @override
  String get cartGrandDiscount => 'Tổng voucher giảm';

  @override
  String get cartGrandTotal => 'Tổng tiền nếu tính hết';

  @override
  String get cartUnavailableShopName => 'Cửa hàng không khả dụng';

  @override
  String cartAppliedVoucher(Object code) {
    return 'Đã áp dụng: $code';
  }

  @override
  String get cartRemoveVoucher => 'Bỏ mã';

  @override
  String get cartVoucherFieldLabel => 'Mã voucher của shop';

  @override
  String get cartCheckVoucher => 'Kiểm tra';

  @override
  String get cartShopSubtotal => 'Tạm tính';

  @override
  String get cartShopDiscount => 'Voucher giảm';

  @override
  String get cartShopTotal => 'Còn lại';

  @override
  String get cartBadgeTooltip => 'Giỏ hàng';

  @override
  String get buyerCheckResultTitle => 'Kết quả kiểm tra';

  @override
  String get buyerCheckViewStore => 'Xem cửa hàng';

  @override
  String get buyerCheckRetake => 'Chụp lại';

  @override
  String get buyerCheckVoucherSaved => 'Đã lưu voucher vào ví';

  @override
  String get buyerCheckLocationNear => 'Ghi nhận tại quầy';

  @override
  String get buyerCheckLocationNeedsMore => 'Cần thêm lượt xác nhận';

  @override
  String get buyerCheckLocationNearBody =>
      'Bạn đang ở gần cửa hàng. Ghi nhận này được tính vào dữ liệu gần đây.';

  @override
  String get buyerCheckLocationNeedsMoreBody =>
      'Bạn không ở gần cửa hàng. Ghi nhận này chỉ dùng để tham khảo.';

  @override
  String get buyerCheckVerdictTitle => 'So với dữ liệu gần nhất';

  @override
  String buyerCheckVerdictValue(Object verdict) {
    return 'Kết quả: $verdict';
  }

  @override
  String get buyerCheckVerdictBody =>
      'Kết quả dựa trên ảnh bạn gửi và thông tin đã ghi nhận.';

  @override
  String get buyerCheckVoucherTitle => 'Kiểm tra voucher';

  @override
  String get buyerCheckVoucherCodeHint => 'VD: FRESH20';

  @override
  String get buyerCheckVoucherDiscount => 'Giảm';

  @override
  String get buyerCheckVoucherRemaining => 'Còn lại';

  @override
  String get buyerCheckOpenWallet => 'Mở ví';

  @override
  String get exploreTitle => 'Khám phá cửa hàng';

  @override
  String get exploreStoreTitle => 'Cửa hàng';

  @override
  String get exploreNearbyStoresTitle => 'Cửa hàng gần bạn';

  @override
  String get exploreAllStoresTitle => 'Tất cả cửa hàng';

  @override
  String get exploreNoResults => 'Không tìm thấy cửa hàng phù hợp';

  @override
  String get exploreSearchHint => 'Tìm tên cửa hàng hoặc địa chỉ...';

  @override
  String get exploreDirections => 'Xem đường';

  @override
  String get exploreYourLocation => 'Vị trí của bạn';

  @override
  String get exploreOpenMap => 'Mở bản đồ';

  @override
  String get exploreTopRatedBadge => 'Đánh giá tốt';

  @override
  String exploreRatingLabel(Object rating) {
    return ' $rating điểm đánh giá';
  }

  @override
  String get exploreLocateDemo => 'Đã căn về vị trí gần bạn (demo)';

  @override
  String get exploreFilterTopRated => 'Đánh giá tốt';

  @override
  String get exploreFilterRecorded => 'Có ghi nhận';

  @override
  String get exploreFilterNearby => 'Gần bạn';

  @override
  String get exploreFilterNewest => 'Mới nhất';

  @override
  String get commonIncreaseQuantity => 'Tăng số lượng';

  @override
  String get accountProfileTitle => 'Hồ sơ cá nhân';

  @override
  String get accountProfileUpdated => 'Đã cập nhật hồ sơ';

  @override
  String get accountLogoutTitle => 'Đăng xuất';

  @override
  String get accountLogoutPrompt => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get accountModeSwitchedSeller => 'Đã chuyển sang chế độ người bán';

  @override
  String get accountModeSwitchedBuyer => 'Đã chuyển sang chế độ người mua';

  @override
  String get accountCurrentMode => 'Chế độ hiện tại';

  @override
  String get accountSellerManagement => 'Quản lý bán hàng';

  @override
  String get accountBuyerActivity => 'Hoạt động mua hàng';

  @override
  String get accountSettings => 'Cài đặt';

  @override
  String get accountMyProducts => 'Sản phẩm của tôi';

  @override
  String get accountStoreInfo => 'Thông tin cửa hàng';

  @override
  String get sellerShopSaved => 'Đã lưu thông tin cửa hàng demo';

  @override
  String get sellerShopNameLabel => 'Tên cửa hàng';

  @override
  String get sellerShopDescriptionLabel => 'Mô tả';

  @override
  String get sellerShopAddressLabel => 'Địa chỉ';

  @override
  String get sellerShopFootnote =>
      'Thông tin này dùng để hiển thị trên trang cửa hàng và tem sản phẩm.';

  @override
  String sellerShopGradeSummary(Object grade, Object rating) {
    return 'Hạng $grade - $rating điểm';
  }

  @override
  String get sellerShopPledgesMetric => 'Ghi nhận';

  @override
  String get sellerShopWarningsMetric => 'Cảnh báo';

  @override
  String get sellerProductNoShop => 'Tài khoản của bạn chưa có cửa hàng.';

  @override
  String get sellerProductCreateTitle => 'Thêm sản phẩm mới';

  @override
  String get sellerProductSavedDraft => 'Đã lưu sản phẩm nháp';

  @override
  String get sellerProductImageSelectedDemo => 'Đã chọn ảnh sản phẩm demo';

  @override
  String get sellerProductImageRemoved => 'Đã bỏ ảnh sản phẩm';

  @override
  String get sellerProductStateAll => 'Tất cả';

  @override
  String get sellerProductStatePublished => 'Đang bán';

  @override
  String get sellerProductStateDraft => 'Bản nháp';

  @override
  String get sellerProductStateArchived => 'Đã ẩn';

  @override
  String get sellerCategoryBeef => 'Thịt bò';

  @override
  String get sellerCategoryPork => 'Thịt heo';

  @override
  String get sellerCategoryChicken => 'Thịt gà';

  @override
  String get sellerCategorySeafood => 'Hải sản';

  @override
  String get sellerCategoryPoultry => 'Gia cầm';

  @override
  String get sellerCategoryOther => 'Khác';

  @override
  String get sellerProductFreshnessWithImage =>
      'Sản phẩm mới tạo, đã có ảnh demo.';

  @override
  String get sellerProductFreshnessWithoutImage => 'Sản phẩm mới tạo.';

  @override
  String get sellerProductImageTitle => 'Ảnh sản phẩm';

  @override
  String get sellerProductImageReady => 'Ảnh demo đã sẵn sàng';

  @override
  String get sellerProductImageSelect => 'Chọn ảnh demo';

  @override
  String get sellerProductNameLabel => 'Tên sản phẩm';

  @override
  String get sellerProductPriceLabel => 'Giá bán';

  @override
  String get sellerProductCategoryLabel => 'Danh mục';

  @override
  String get sellerProductDescriptionLabel => 'Mô tả';

  @override
  String get sellerProductTagsLabel => 'Thẻ gợi ý';

  @override
  String get sellerProductTagsHint => 'VD: tươi, sạch, hữu cơ';

  @override
  String get sellerProductSave => 'Lưu sản phẩm';

  @override
  String get sellerProductActionViewDetail => 'Xem chi tiết';

  @override
  String get sellerProductActionViewHistory => 'Xem lịch sử';

  @override
  String get sellerProductActionAddPledge => 'Thêm ghi nhận';

  @override
  String get sellerProductEmpty => 'Chưa có sản phẩm nào';

  @override
  String sellerProductCategoryValue(Object category) {
    return 'Danh mục: $category';
  }

  @override
  String get sellerProductHistoryShort => 'Lịch sử';

  @override
  String get sellerProductAddPledgeShort => 'Thêm ghi nhận';

  @override
  String get accountExploreStores => 'Khám phá cửa hàng';

  @override
  String get accountScanProducts => 'Quét sản phẩm';

  @override
  String get scannerFrameHint => 'Đưa mã QR hoặc tem sản phẩm vào khung hình';

  @override
  String get scannerCheckingAction => 'Đang kiểm tra...';

  @override
  String get scannerSimulateAction => 'Giả lập quét sản phẩm';

  @override
  String get scannerStatusVerifying => 'Đang kiểm tra vị trí quầy hàng...';

  @override
  String get scannerStatusReady => 'Sẵn sàng kiểm tra sản phẩm';

  @override
  String get scannerOverlayVerifying => 'Đang kiểm tra sản phẩm...';

  @override
  String get accountDarkMode => 'Chế độ tối';

  @override
  String get accountEditProfile => 'Sửa hồ sơ';

  @override
  String get accountHelpAndSupport => 'Hỗ trợ & Trợ giúp';

  @override
  String get accountSaveProfileChanges => 'Lưu thay đổi';

  @override
  String get accountHelpTitle => 'Hỗ trợ';

  @override
  String get accountHelpScanTitle => 'Quét sản phẩm';

  @override
  String get accountHelpScanBody =>
      'Chụp sản phẩm và mã QR để kiểm tra dữ liệu đã ghi nhận.';

  @override
  String get accountHelpStoreTitle => 'Cửa hàng';

  @override
  String get accountHelpStoreBody =>
      'Xem danh sách cửa hàng, đánh giá và sản phẩm gần đây.';

  @override
  String get accountHelpContactTitle => 'Liên hệ';

  @override
  String get accountHelpContactBody =>
      'Gửi email tới support@vngrocery.local khi cần hỗ trợ.';

  @override
  String get voucherWalletTitle => 'Ví voucher';

  @override
  String get voucherWalletAddManualTooltip => 'Thêm thủ công';

  @override
  String get qrLabelTitle => 'Mã QR sản phẩm';

  @override
  String get qrLabelCopied => 'Đã sao chép nội dung tem QR';

  @override
  String get qrLabelPrintTitle => 'In tem QR';

  @override
  String get qrLabelPrintBody =>
      'Tem QR đã được đưa vào hàng đợi in demo. Kiểm tra máy in tại quầy trước khi dán lên sản phẩm.';

  @override
  String get splashSubtitle => 'Kiểm tra giá và sản phẩm gần bạn';

  @override
  String get splashFootnote => 'Dữ liệu từ quầy hàng và cộng đồng';

  @override
  String voucherWalletUsableCount(Object count) {
    return '$count voucher có thể dùng';
  }

  @override
  String voucherWalletTotalCount(Object count) {
    return 'Tổng cộng $count voucher trong ví';
  }

  @override
  String get voucherWalletEmptyTitle => 'Chưa có voucher phù hợp';

  @override
  String get voucherWalletEmptyBody =>
      'Quét sản phẩm, nhập mã hoặc thêm thủ công để lưu voucher vào ví.';

  @override
  String get voucherWalletSectionTitle => 'Voucher của bạn';

  @override
  String get voucherWalletShowUsed => 'Hiện đã dùng';

  @override
  String voucherCodeLabelInline(Object code) {
    return 'Mã: $code';
  }

  @override
  String get manualVoucherTitle => 'Thêm voucher thủ công';

  @override
  String manualVoucherDemoCopied(Object format) {
    return 'Đã copy mã $format demo vào ô mã';
  }

  @override
  String get manualVoucherSaved => 'Đã thêm voucher thủ công vào ví';

  @override
  String get manualVoucherNotice =>
      'Voucher thủ công là thông tin do bạn tự nhập để lưu trữ và sử dụng tại quầy. Nội dung này chưa được cửa hàng xác thực, bạn tự chịu trách nhiệm về điều kiện sử dụng.';

  @override
  String get manualVoucherShopLabel => 'Cửa hàng áp dụng';

  @override
  String get manualVoucherScanQr => 'Quét QR';

  @override
  String get manualVoucherScanBarcode => 'Quét mã vạch';

  @override
  String get manualVoucherCodeLabel => 'Mã voucher';

  @override
  String get manualVoucherCodeRequired => 'Nhập mã voucher';

  @override
  String get manualVoucherTitleLabel => 'Tên gợi nhớ';

  @override
  String get manualVoucherTitleHint => 'VD: Giảm 20% mua thịt cuối tuần';

  @override
  String get manualVoucherNoteLabel => 'Ghi chú của bạn';

  @override
  String get manualVoucherNoteHint =>
      'Điều kiện sử dụng, nguồn nhận mã, lưu ý tại quầy...';

  @override
  String get manualVoucherExpiryLabel => 'Hạn dùng';

  @override
  String get manualVoucherChangeDate => 'Đổi ngày';

  @override
  String get manualVoucherSaveToWallet => 'Lưu vào ví';

  @override
  String get storeDetailTitle => 'Chi tiết cửa hàng';

  @override
  String get storeDetailRecentCheckedProducts => 'Sản phẩm mới kiểm tra';

  @override
  String get storeDetailCopied => 'Đã sao chép thông tin cửa hàng';

  @override
  String get storeDetailNoReceipt => 'Cửa hàng chưa có biên lai sản phẩm';

  @override
  String get storeDetailLatestReceiptTitle =>
      'Sản phẩm đã được kiểm tra gần đây';

  @override
  String get storeDetailLatestReceiptSubtitle => 'Có biên lai trong lịch sử';

  @override
  String get storeDetailViewReceipt => 'Xem biên lai';

  @override
  String get storeDetailProductsTab => 'Sản phẩm';

  @override
  String get storeDetailReviewsTab => 'Đánh giá';

  @override
  String get storeDetailWriteReview => 'Viết đánh giá';

  @override
  String storeShareSummary(Object rating, Object reviewCount) {
    return '$rating điểm đánh giá - $reviewCount lượt đánh giá';
  }

  @override
  String storeProductShopLabel(Object shopId) {
    return 'Cửa hàng: $shopId';
  }

  @override
  String storeProductScore(Object score) {
    return '$score điểm';
  }

  @override
  String get productDetailTitle => 'Thông tin sản phẩm';

  @override
  String productDetailAddedToCart(Object productName) {
    return 'Đã thêm $productName';
  }

  @override
  String get productDetailAddToCart => 'Thêm vào giỏ';

  @override
  String get productDetailCounterImage => 'Ảnh từ quầy';

  @override
  String productDetailPricePerKg(Object price) {
    return 'Giá: $price /kg';
  }

  @override
  String get productDetailLatestScoreTitle => 'ĐIỂM ĐÁNH GIÁ GẦN NHẤT';

  @override
  String get productDetailLatestScoreSubtitle =>
      'Dựa trên ảnh và thông tin đã ghi nhận';

  @override
  String get productDetailCheckAction => 'Gửi ảnh kiểm tra sản phẩm';

  @override
  String get productDetailCheckActionHint =>
      'Hãy chụp ảnh bảng giá hoặc sản phẩm để so với dữ liệu gần nhất.';

  @override
  String get productDetailCounterInfoTitle => 'Thông tin quầy hàng';

  @override
  String get productDetailShopCodeLabel => 'Mã cửa hàng';

  @override
  String get productDetailFreshnessNoteLabel => 'Ghi chú sản phẩm';

  @override
  String get productDetailViewStoreInfo => 'Xem thông tin cửa hàng';

  @override
  String get reviewTitle => 'Đánh giá cửa hàng';

  @override
  String get reviewIntroTitle => 'Trải nghiệm của bạn thế nào?';

  @override
  String get reviewIntroBody =>
      'Đánh giá của bạn giúp cộng đồng chọn sản phẩm tốt hơn.';

  @override
  String get reviewCommentHint => 'Nhập nhận xét của bạn tại đây...';

  @override
  String get reviewPhotoAttached => 'Đã thêm hình ảnh';

  @override
  String get reviewPhotoAdd => 'Thêm hình ảnh';

  @override
  String get reviewSubmit => 'Gửi đánh giá';

  @override
  String get reviewSubmitted => 'Đã gửi đánh giá. Cảm ơn bạn!';

  @override
  String get reviewSubmittedWithPhoto => 'Đã gửi đánh giá kèm ảnh. Cảm ơn bạn!';

  @override
  String get reviewPhotoAttachedDemo => 'Đã đính kèm ảnh demo';

  @override
  String get reviewPhotoRemovedDemo => 'Đã bỏ ảnh đính kèm';

  @override
  String get scoreBadgeLabel => 'Điểm đánh giá';

  @override
  String get voucherManualBadge => 'Tự nhập';

  @override
  String get voucherUseTitle => 'Dùng voucher';

  @override
  String get voucherManualUseWarning =>
      'Thông tin voucher này do bạn tự nhập và chưa được cửa hàng xác thực. Hãy kiểm tra lại điều kiện tại quầy trước khi sử dụng.';

  @override
  String get voucherUsed => 'Voucher đã dùng';

  @override
  String get voucherMarkUsed => 'Đánh dấu đã dùng';

  @override
  String get voucherViewStore => 'Xem cửa hàng áp dụng';

  @override
  String get voucherConfirmUseTitle => 'Xác nhận dùng voucher';

  @override
  String get voucherConfirmUseBody =>
      'Voucher chỉ dùng được 1 lần. Sau khi xác nhận, voucher sẽ chuyển sang trạng thái đã dùng.';

  @override
  String get voucherMarkedUsed => 'Đã sử dụng voucher';

  @override
  String get voucherUsageConditions => 'Điều kiện sử dụng';

  @override
  String voucherRuleStore(Object shopName) {
    return 'Chỉ áp dụng tại $shopName';
  }

  @override
  String voucherRuleMinSpend(Object amount) {
    return 'Đơn từ $amount';
  }
}
