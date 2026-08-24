// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String a11yPriceChart(Object days, Object low, Object high) {
    return 'Biểu đồ giá $days ngày, thấp nhất $low, cao nhất $high';
  }

  @override
  String get a11yCopyHash => 'Chép mã băm đầy đủ';

  @override
  String a11yFreshnessScore(Object score) {
    return 'Điểm độ tươi $score trên 10';
  }

  @override
  String get a11yBack => 'Quay lại';

  @override
  String get a11yToggleFlash => 'Bật/tắt đèn flash';

  @override
  String get a11yCloseCamera => 'Đóng camera';

  @override
  String get a11yShowPassword => 'Hiện mật khẩu';

  @override
  String get a11yHidePassword => 'Ẩn mật khẩu';

  @override
  String a11yRateStars(Object count) {
    return 'Chấm $count sao';
  }

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
      'Đăng nhập để kiểm tra sản phẩm, xem bản đồ và giá tại cửa hàng.';

  @override
  String get authRegisterInfo =>
      'Tạo tài khoản để kiểm tra sản phẩm và lưu đánh giá của bạn.';

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
      'Nhập email tài khoản để nhận mã đặt lại mật khẩu.';

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
  String get onboardingSkip => 'Bỏ qua';

  @override
  String get onboardingContinue => 'Tiếp tục';

  @override
  String get onboardingStart => 'Bắt đầu';

  @override
  String get authChangePassword => 'Đổi mật khẩu';

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
  String get accountSellerNotApproved =>
      'Muốn mở cửa hàng? Liên hệ quản trị viên để được cấp quyền người bán.';

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
  String get sellerShopSaved => 'Đã lưu thông tin cửa hàng';

  @override
  String get changeReasonLabel => 'Lý do thay đổi';

  @override
  String get changeReasonHint => 'Ví dụ: đổi địa chỉ sau khi chuyển sạp';

  @override
  String get changeReasonTooShort =>
      'Ghi ít nhất 5 ký tự để người mua hiểu vì sao';

  @override
  String get changeReasonExplainer =>
      'Lý do được ký cùng thay đổi và hiện trong lịch sử sản phẩm — không sửa lại được.';

  @override
  String get commentsTitle => 'Bình luận của người mua';

  @override
  String get commentsEmpty => 'Chưa có ai bình luận sản phẩm này.';

  @override
  String get commentsFailed => 'Không đọc được bình luận.';

  @override
  String get commentsFailedBody => 'Kiểm tra kết nối rồi thử lại.';

  @override
  String get commentsNeedCheck =>
      'Kiểm tra sản phẩm tại quầy rồi mới bình luận được — bình luận phải có bằng chứng.';

  @override
  String get commentsWriteHint => 'Bạn thấy hàng thế nào?';

  @override
  String get commentsSend => 'Gửi bình luận';

  @override
  String get commentsTooShort => 'Ghi ít nhất 5 ký tự';

  @override
  String get commentsSent => 'Đã gửi bình luận';

  @override
  String get commentsSendFailed => 'Không gửi được bình luận';

  @override
  String get commentsPendingMine => 'Đang chờ cửa hàng duyệt';

  @override
  String get commentsRejectedMine => 'Cửa hàng đã từ chối bình luận này';

  @override
  String get commentsVerifiedBadge => 'Đã kiểm tra tại quầy';

  @override
  String get commentsModerationOn =>
      'Cửa hàng này duyệt bình luận trước khi hiển thị';

  @override
  String commentsWithheld(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bình luận chưa được hiển thị',
    );
    return '$_temp0';
  }

  @override
  String get commentsModerationEffect =>
      'Bình luận bị giữ lại làm giảm điểm tin cậy của cửa hàng.';

  @override
  String get commentsWithdraw => 'Gỡ bình luận của tôi';

  @override
  String get commentsWithdrawReason => 'Vì sao gỡ?';

  @override
  String get commentsWithdrawn => 'Đã gỡ bình luận';

  @override
  String get sellerCommentsTitle => 'Duyệt bình luận';

  @override
  String get sellerCommentsModerationLabel =>
      'Duyệt bình luận trước khi hiển thị';

  @override
  String get sellerCommentsModerationExplainer =>
      'Bật thì bình luận mới phải chờ bạn duyệt. Người mua vẫn thấy số bình luận đang bị giữ, và phần bình luận trong điểm tin cậy bị trừ theo tỉ lệ bạn không cho hiển thị.';

  @override
  String get sellerCommentsApprove => 'Cho hiển thị';

  @override
  String get sellerCommentsReject => 'Không hiển thị';

  @override
  String get sellerCommentsReasonLabel => 'Lý do quyết định';

  @override
  String get sellerCommentsApproveHint =>
      'Ví dụ: bình luận đúng với hàng hôm nay';

  @override
  String get sellerCommentsReasonHint => 'Ví dụ: bình luận nhầm sản phẩm khác';

  @override
  String get sellerCommentsEmpty => 'Không có bình luận nào đang chờ.';

  @override
  String get sellerCommentsEmptyBody =>
      'Bình luận mới sẽ chờ ở đây khi bạn bật duyệt bình luận. Tắt duyệt thì bình luận hiện ngay và điểm tin cậy không bị trừ.';

  @override
  String get sellerCommentsEmptyAction => 'Về cài đặt cửa hàng';

  @override
  String get sellerCommentsDone => 'Đã lưu quyết định';

  @override
  String get sellerCommentsFailed => 'Không lưu được quyết định';

  @override
  String get sellerPledgeNoteLabel => 'Vì sao chấm điểm này?';

  @override
  String get sellerPledgeNoteHint => 'Ví dụ: hàng mới nhập sáng nay';

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
  String get sellerShopNotRatedYet => 'Chưa có đánh giá';

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
  String get sellerProductSaved => 'Đã đăng sản phẩm';

  @override
  String get sellerProductSaveFailed =>
      'Không lưu được sản phẩm. Kiểm tra kết nối rồi thử lại.';

  @override
  String get sellerProductImageUploadFailed =>
      'Không tải được ảnh lên. Sản phẩm đã lưu nhưng chưa có ảnh.';

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
  String get sellerProductFreshnessWithImage => 'Sản phẩm mới tạo, đã có ảnh.';

  @override
  String get sellerProductFreshnessWithoutImage => 'Sản phẩm mới tạo.';

  @override
  String get sellerProductImageTitle => 'Ảnh sản phẩm';

  @override
  String get sellerProductImageReady => 'Đã có ảnh sản phẩm';

  @override
  String get sellerProductImageSelect => 'Chụp ảnh sản phẩm';

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
  String get sellerPledgeCategoryBeef => 'Thịt bò';

  @override
  String get sellerPledgeCategoryPork => 'Thịt lợn';

  @override
  String get sellerPledgeCategoryChicken => 'Thịt gà';

  @override
  String get sellerPledgeCategorySeafood => 'Hải sản';

  @override
  String get sellerPledgeCategoryOther => 'Khác';

  @override
  String get sellerPledgeStepCapture => 'Bước 1: Chụp ảnh hàng';

  @override
  String get sellerPledgeStepEvaluate => 'Bước 2: Chấm điểm sản phẩm';

  @override
  String get sellerPledgeStepConfirm => 'Bước 3: Xác nhận ghi nhận';

  @override
  String get sellerPledgeRecordTimeJustNow => 'Vừa xong';

  @override
  String get sellerPledgeRecordTitle => 'Người bán thêm ghi nhận mới';

  @override
  String sellerPledgeRecordDescription(Object score, Object category) {
    return 'Điểm đánh giá $score/10 cho loại: $category.';
  }

  @override
  String get sellerPledgeCaptureInvalidImage =>
      'Ảnh không dùng được. Chụp lại rõ hơn.';

  @override
  String get sellerPledgeCaptureUnavailable =>
      'Dịch vụ chấm điểm ảnh đang bận. Thử lại sau ít phút.';

  @override
  String get sellerPledgeCaptureFailed =>
      'Không chấm được ảnh. Kiểm tra kết nối rồi chụp lại.';

  @override
  String get sellerPledgeCaptureAction => 'Chụp ảnh hàng hóa';

  @override
  String get sellerPledgeSuggestedScoreTitle => 'ĐIỂM GỢI Ý TỪ ẢNH';

  @override
  String get sellerPledgeSellerScoreTitle => 'ĐIỂM NGƯỜI BÁN NHẬP';

  @override
  String get sellerPledgeScoreRange => 'Điểm từ 0 đến 10';

  @override
  String get sellerPledgeSaveFailed =>
      'Không lưu được ghi nhận. Kiểm tra kết nối rồi thử lại.';

  @override
  String get sellerPledgeSellerScoreLabel => 'Nhập điểm đánh giá (0-10)';

  @override
  String get sellerPledgeContinueConfirm => 'Tiếp tục xác nhận';

  @override
  String sellerPledgeCategoryValue(Object category) {
    return 'Loại: $category';
  }

  @override
  String get sellerPledgeRecordContentTitle => 'NỘI DUNG GHI NHẬN';

  @override
  String sellerPledgeRecordPreview(Object score) {
    return 'Tôi ghi nhận sản phẩm tại quầy với điểm đánh giá $score.';
  }

  @override
  String get sellerPledgeConfirmSave => 'Xác nhận & lưu ghi nhận';

  @override
  String get sellerPledgeSaved => 'Đã lưu ghi nhận sản phẩm.';

  @override
  String get accountExploreStores => 'Khám phá cửa hàng';

  @override
  String get accountScanProducts => 'Quét sản phẩm';

  @override
  String get scannerFrameHint => 'Đưa mã QR hoặc tem sản phẩm vào khung hình';

  @override
  String get scannerCheckingAction => 'Đang kiểm tra...';

  @override
  String get scannerSimulateAction => 'Chụp & phân tích AI';

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
  String get commonBuyer => 'Người mua';

  @override
  String get commonSeller => 'Người bán';

  @override
  String get accountSellerModeBody =>
      'Chế độ người bán: quản lý cửa hàng, sản phẩm và ghi nhận.';

  @override
  String get accountBuyerModeBody =>
      'Chế độ người mua: khám phá, quét mã và kiểm tra sản phẩm.';

  @override
  String get homeGreeting => 'Xin chào,';

  @override
  String get homeLocationDistrict1 => 'Quận 1';

  @override
  String get homeSearchHint => 'Tìm shop, sản phẩm...';

  @override
  String get homeScanHeroBody => 'Kiểm tra với dữ liệu đã ghi nhận';

  @override
  String get homeSeeAll => 'Xem tất cả';

  @override
  String get homeCategoriesTitle => 'Danh mục';

  @override
  String get homeCategoryPork => 'Thịt heo';

  @override
  String get homeCategoryBeef => 'Thịt bò';

  @override
  String get homeCategoryPoultry => 'Gia cầm';

  @override
  String get homeCategorySeafood => 'Hải sản';

  @override
  String get homeTopRatedStoresTitle => 'Cửa hàng được đánh giá tốt';

  @override
  String get homeRecentChecksTitle => 'Sản phẩm mới kiểm tra';

  @override
  String homeShopRatingValue(Object rating) {
    return ' $rating';
  }

  @override
  String homeShopReviewCount(Object count) {
    return '$count đánh giá';
  }

  @override
  String get aiFreshnessTitle => 'Gửi ảnh kiểm tra';

  @override
  String get aiFreshnessHeading => 'Chụp ảnh sản phẩm tại quầy';

  @override
  String get aiFreshnessBody =>
      'Ảnh này giúp so với thông tin đã ghi nhận gần đây.';

  @override
  String get aiFreshnessAnalyzing => 'Đang so với dữ liệu gần nhất...';

  @override
  String get aiFreshnessAction => 'Chụp ảnh & kiểm tra';

  @override
  String get pledgeOverviewTitle => 'Tổng quan bán hàng';

  @override
  String get pledgeOverviewMetricsTitle => 'Chỉ số cửa hàng';

  @override
  String get pledgeOverviewHint =>
      'Chụp trong điều kiện đủ sáng để điểm ổn định. Mỗi ghi nhận đều được neo lên blockchain.';

  @override
  String get voucherWalletTitle => 'Ví voucher';

  @override
  String get voucherWalletAddManualTooltip => 'Thêm thủ công';

  @override
  String get qrLabelTitle => 'Mã QR sản phẩm';

  @override
  String get qrLabelCopied => 'Đã sao chép nội dung tem QR';

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
  String get reviewPhotoAttached => 'Đã đính kèm ảnh';

  @override
  String get reviewPhotoAdd => 'Thêm hình ảnh';

  @override
  String get reviewSubmit => 'Gửi đánh giá';

  @override
  String get reviewSubmitted => 'Đã gửi đánh giá. Cảm ơn bạn!';

  @override
  String get reviewSubmittedWithPhoto => 'Đã gửi đánh giá kèm ảnh. Cảm ơn bạn!';

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

  @override
  String get trustProofVerifiedLabel => 'Đã xác thực on-chain';

  @override
  String get trustProofPendingLabel => 'Đang neo lên blockchain';

  @override
  String get trustProofWarningLabel => 'Phát hiện sai lệch';

  @override
  String get trustProofRevokedLabel => 'Cam kết đã bị thu hồi';

  @override
  String get trustProofUnknownLabel => 'Chưa xác thực được';

  @override
  String get trustProofVerifiedSummary =>
      'Cam kết độ tươi đã được neo lên blockchain và vẫn khớp.';

  @override
  String get trustProofPendingSummary =>
      'Cam kết đã được tạo nhưng chưa neo xong lên blockchain.';

  @override
  String get trustProofWarningSummary =>
      'Dữ liệu lưu trữ không còn khớp với bản ghi trên blockchain.';

  @override
  String get trustProofRevokedSummary =>
      'Cam kết này đã bị thu hồi, không nên tin cậy nữa.';

  @override
  String get trustProofUnknownSummary =>
      'Chưa kiểm tra được bản ghi blockchain của cam kết này.';

  @override
  String get trustGradeExcellent => 'Rất tốt';

  @override
  String get trustGradeGood => 'Tốt';

  @override
  String get trustGradeWatch => 'Cần theo dõi';

  @override
  String get trustGradeRisk => 'Rủi ro';

  @override
  String get trustScoreTitle => 'Điểm tin cậy';

  @override
  String get trustScoreNoData => 'Chưa đủ dữ liệu để đánh giá cửa hàng này.';

  @override
  String get trustScoreBreakdown => 'Điểm này được tính từ';

  @override
  String get trustScoreReasons => 'Lý do';

  @override
  String trustScoreFormula(Object version) {
    return 'Công thức $version';
  }

  @override
  String get trustComponentPledge => 'Cam kết người bán';

  @override
  String get trustComponentReview => 'Đánh giá khách hàng';

  @override
  String get trustComponentBuyerCheck => 'Kiểm chứng người mua';

  @override
  String get trustComponentConsistency => 'Tính nhất quán';

  @override
  String get trustComponentRecency => 'Hoạt động gần đây';

  @override
  String get trustComponentCoverage => 'Độ phủ dữ liệu';

  @override
  String get trustReasonPartialTrustData => 'Mới có một phần dữ liệu tin cậy';

  @override
  String get trustReasonNoCustomerReviews => 'Chưa có đánh giá của khách hàng';

  @override
  String get trustReasonNoBuyerChecks => 'Chưa có người mua nào kiểm chứng';

  @override
  String get trustReasonNoEligibleBuyerChecks =>
      'Không có kiểm chứng nào được tính điểm';

  @override
  String get trustReasonBuyerChecksConfirmed =>
      'Người mua kiểm chứng khớp với cam kết';

  @override
  String get trustReasonBuyerChecksHighRisk =>
      'Kiểm chứng của người mua cho thấy rủi ro cao';

  @override
  String get trustReasonBuyerChecksConsistencyIssues =>
      'Kiểm chứng không khớp với cam kết';

  @override
  String get trustReasonDuplicateBuyerChecks =>
      'Các kiểm chứng trùng lặp đã bị giảm trọng số';

  @override
  String get trustReasonPledgesConsistent => 'Cam kết nhất quán với kiểm chứng';

  @override
  String get trustReasonLimitedConsistencyData =>
      'Chưa đủ dữ liệu để đánh giá tính nhất quán';

  @override
  String get trustReasonNoConsistencySignals =>
      'Chưa có tín hiệu nhất quán nào';

  @override
  String get trustReasonLimitedSignalCoverage =>
      'Dữ liệu tin cậy mới phủ được ít sản phẩm';

  @override
  String get trustReasonRecentActivity => 'Cửa hàng có hoạt động gần đây';

  @override
  String get trustReasonNoRecentActivity =>
      'Cửa hàng không có hoạt động gần đây';

  @override
  String get trustReasonNoPledge => 'Sản phẩm này chưa có cam kết độ tươi';

  @override
  String get trustReasonNoSellerPledges => 'Người bán chưa tạo cam kết nào';

  @override
  String get trustReasonSomePledgesLowConfidence =>
      'Một số cam kết có độ tin cậy thấp';

  @override
  String get blockchainProofTitle => 'Chứng nhận blockchain';

  @override
  String get blockchainProofPledge => 'Cam kết';

  @override
  String get blockchainProofTxHash => 'Mã giao dịch';

  @override
  String get blockchainProofBlock => 'Khối';

  @override
  String get blockchainProofDataHash => 'Mã băm dữ liệu';

  @override
  String get blockchainProofAnchoredAt => 'Thời điểm neo';

  @override
  String get blockchainProofMatch => 'Mã băm khớp với blockchain';

  @override
  String get blockchainProofYes => 'Có';

  @override
  String get blockchainProofNo => 'Không';

  @override
  String get blockchainProofNoRecord =>
      'Cam kết này chưa có bản ghi trên blockchain.';

  @override
  String get blockchainProofRefresh => 'Làm mới';

  @override
  String get blockchainProofCopied => 'Đã sao chép';

  @override
  String get blockchainProofCopyHint => 'Chạm vào giá trị để sao chép';

  @override
  String get blockchainProofScore => 'Độ tươi cam kết';

  @override
  String get buyerCheckCompareTitle => 'Cam kết và kết quả đo';

  @override
  String get buyerCheckPledged => 'Người bán cam kết';

  @override
  String get buyerCheckMeasured => 'Đo được lúc này';

  @override
  String get buyerCheckDelta => 'Chênh lệch';

  @override
  String get buyerCheckCategoryMatch => 'Loại sản phẩm khớp';

  @override
  String get buyerCheckNoPledge => 'Sản phẩm này chưa có cam kết để đối chiếu.';

  @override
  String get buyerCheckTrusted => 'Khớp với cam kết';

  @override
  String get buyerCheckNotTrusted => 'Không khớp với cam kết';

  @override
  String buyerCheckConfidence(Object percent) {
    return 'Độ tin cậy AI $percent%';
  }

  @override
  String get qrScanTitle => 'Quét mã lô hàng';

  @override
  String get qrScanHint => 'Đưa camera vào mã trên tem';

  @override
  String get qrScanNotOurCode => 'Đây không phải mã VnGrocery';

  @override
  String get qrScanExpired => 'Mã đã hết hạn, hãy xin người bán tem mới';

  @override
  String get qrScanUnsupported => 'Mã này cần phiên bản ứng dụng mới hơn';

  @override
  String get qrScanCameraError => 'Không mở được camera';

  @override
  String get qrScanChecking => 'Đang kiểm tra...';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navExplore => 'Khám phá';

  @override
  String get navScanProducts => 'Quét sản phẩm';

  @override
  String get navStores => 'Cửa hàng';

  @override
  String get navVoucherWallet => 'Ví voucher';

  @override
  String get navAccount => 'Tài khoản';

  @override
  String get navSellerOverview => 'Tổng quan';

  @override
  String get navSellerProducts => 'Sản phẩm';

  @override
  String get navSellerStore => 'Cửa hàng';

  @override
  String get onboardingTitle1 => 'Xem dữ liệu sản phẩm';

  @override
  String get onboardingBody1 =>
      'Mỗi sản phẩm có điểm đánh giá và lịch sử ghi nhận rõ ràng.';

  @override
  String get onboardingTitle2 => 'Chụp ảnh kiểm tra';

  @override
  String get onboardingBody2 =>
      'Quét mã hoặc chụp ảnh tại quầy để kiểm tra với dữ liệu gần nhất.';

  @override
  String get onboardingTitle3 => 'Ra quyết định dễ dàng';

  @override
  String get onboardingBody3 =>
      'Dễ so sánh hơn khi thông tin đến từ các lượt ghi nhận thực tế.';

  @override
  String get sellerShopStatusTitle => 'Tình trạng shop';

  @override
  String get sellerStatusLabel => 'Trạng thái';

  @override
  String get sellerTotalRecords => 'Tổng ghi nhận';

  @override
  String get sellerLatestReceipt => 'Biên lai gần nhất';

  @override
  String get sellerNone => 'Chưa có';

  @override
  String get sellerNeedsReview => 'Cần xem lại';

  @override
  String get sellerStable => 'Ổn định';

  @override
  String get sellerAddRecordTitle => 'Thêm ghi nhận sản phẩm';

  @override
  String get sellerAddRecordBody => 'Chọn sản phẩm và lưu thông tin tại quầy.';

  @override
  String get sellerNeedProductFirst => 'Cần tạo sản phẩm trước khi ghi nhận.';

  @override
  String get sellerProductsLabel => 'Sản phẩm';

  @override
  String get sellerPickProductTitle => 'Xem lịch sử của sản phẩm nào?';

  @override
  String sellerReceiptCopied(Object code) {
    return 'Đã chép mã biên lai $code';
  }

  @override
  String get sellerHistoryNeedsProduct =>
      'Có sản phẩm rồi mới có lịch sử để xem.';

  @override
  String get sellerHistoryLabel => 'Lịch sử';

  @override
  String get sellerTrustLabel => 'Độ tin cậy';

  @override
  String get sellerRecordsToday => 'Ghi nhận hôm nay';

  @override
  String get sellerBuyerAlerts => 'Cảnh báo từ người mua';

  @override
  String voucherDiscountPercent(Object value) {
    return 'Giảm $value%';
  }

  @override
  String voucherDiscountAmount(Object amount) {
    return 'Giảm $amount';
  }

  @override
  String get voucherManualInfo => 'Thông tin tự nhập';

  @override
  String voucherMinSpendFrom(Object amount) {
    return 'Từ $amount';
  }

  @override
  String get voucherExpiredLabel => 'Hết hạn';

  @override
  String get voucherUsableLabel => 'Có thể dùng';

  @override
  String get voucherReadyLabel => 'Sẵn sàng sử dụng';

  @override
  String get voucherPerYourInput => 'Theo thông tin bạn tự nhập';

  @override
  String get qrLabelReadyTitle => 'Mã QR đã sẵn sàng!';

  @override
  String get qrLabelReadyBody => 'Hãy in và dán mã này lên bao bì sản phẩm.';

  @override
  String qrLabelRecordId(Object id) {
    return 'Mã ghi nhận: $id';
  }

  @override
  String get qrLabelScanHint => 'Quét mã để kiểm tra thông tin sản phẩm';

  @override
  String get qrLabelBackHome => 'Về màn hình chính';

  @override
  String get homeAddToCart => 'Thêm vào giỏ';

  @override
  String homeAddedToCart(Object name) {
    return 'Đã thêm $name';
  }

  @override
  String get homeRecentChecks => 'Sản phẩm mới kiểm tra';

  @override
  String get pledgeTimelineTitle => 'Dòng thời gian sản phẩm';

  @override
  String historyShowMore(Object count) {
    return 'Xem thêm $count mục';
  }

  @override
  String get historyShowLess => 'Thu gọn';

  @override
  String get pledgeHistoryEmpty => 'Chưa có lịch sử ghi nhận';

  @override
  String pledgeOriginalReceipt(Object id) {
    return 'Biên lai gốc: $id';
  }

  @override
  String get scannerNoCamera => 'Không tìm thấy camera';

  @override
  String get scannerOpeningCamera => 'Đang mở camera...';

  @override
  String scannerConfidence(Object percent) {
    return 'Tin cậy: $percent%';
  }

  @override
  String get voucherUsedShort => 'Đã dùng';

  @override
  String get navScanShort => 'Quét';

  @override
  String get sideMenuFootnote => 'Dữ liệu từ quầy hàng và cộng đồng';

  @override
  String get roleSeller => 'Người bán';

  @override
  String get roleBuyer => 'Người mua';

  @override
  String get voucherBarcode => 'Mã vạch';

  @override
  String get exploreNearbyTitle => 'Cửa hàng gần bạn';

  @override
  String get exploreViewStore => 'Xem cửa hàng';

  @override
  String get exploreSearchNearby => 'Tìm cửa hàng gần bạn';

  @override
  String get buyerCheckScanFirst =>
      'Hãy quét tem pledge hợp lệ trước khi kiểm tra.';

  @override
  String get authErrorInvalidCredentials => 'Email hoặc mật khẩu không đúng';

  @override
  String get authErrorAccountDeleted => 'Tài khoản này đã bị khoá';

  @override
  String get authErrorEmailTaken => 'Email này đã được đăng ký';

  @override
  String get authErrorInvalidInput =>
      'Email hoặc mật khẩu chưa hợp lệ. Mật khẩu cần ít nhất 8 ký tự.';

  @override
  String get authErrorNetwork =>
      'Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại.';

  @override
  String get authErrorGeneric =>
      'Đăng nhập không thành công. Vui lòng thử lại.';

  @override
  String get authGoogleTokenError => 'Không lấy được Google ID token';

  @override
  String get pledgeHistoryTitle => 'Lịch sử ghi nhận';

  @override
  String get scoreLabel => 'Điểm đánh giá';

  @override
  String qrLabelClipboard(Object pledgeId) {
    return 'VnGrocery Check\nMã ghi nhận: $pledgeId\nQuét mã để kiểm tra thông tin sản phẩm';
  }

  @override
  String get sellerModeSubtitle => 'Chế độ người bán';

  @override
  String scannerConfidenceValue(Object percent) {
    return 'Tin cậy: $percent%';
  }

  @override
  String get homeCategoryFreshProduce => 'Nông sản tươi';

  @override
  String get homeCategoryMeat => 'Thịt';

  @override
  String get homeCategoryVegetables => 'Rau củ';

  @override
  String get homeCategoryFruit => 'Trái cây';

  @override
  String get reviewSubmitFailed => 'Không gửi được đánh giá. Vui lòng thử lại.';

  @override
  String get cameraCaptureTitle => 'Chụp ảnh';

  @override
  String get cameraCaptureAction => 'Chụp';

  @override
  String get pledgeCaptureHint => 'Đưa sản phẩm cần ghi nhận vào khung hình';

  @override
  String get reviewPhotoHint => 'Chụp ảnh để đính kèm vào đánh giá';

  @override
  String get reviewPhotoRemoved => 'Đã bỏ ảnh';

  @override
  String get sellerProductImageHint => 'Chụp ảnh sản phẩm cho tin đăng';

  @override
  String get sellerProductImageAttached => 'Đã thêm ảnh';

  @override
  String manualVoucherCodeScanned(Object format) {
    return 'Đã quét mã $format';
  }

  @override
  String get qrLabelCopyAction => 'Sao chép thông tin tem';

  @override
  String get authPasswordReset => 'Đã đặt lại mật khẩu';

  @override
  String get authPasswordChanged => 'Đã đổi mật khẩu thành công';

  @override
  String get pledgeHistoryDefaultTitle => 'Ghi nhận độ tươi';

  @override
  String pledgeHistoryScoreLine(Object score, Object category) {
    return 'Điểm $score/10 · $category';
  }

  @override
  String pledgeHistoryScoreOnly(Object score) {
    return 'Điểm $score/10';
  }

  @override
  String qrLabelClipboardPledge(Object pledgeId) {
    return 'Mã ghi nhận: $pledgeId';
  }

  @override
  String qrLabelClipboardBundle(Object bundleId) {
    return 'Mã lô: $bundleId';
  }

  @override
  String qrLabelClipboardToken(Object token) {
    return 'Token: $token';
  }

  @override
  String get reviewAnonymousAuthor => 'Người dùng';

  @override
  String get homeLoadFailedTitle => 'Không tải được dữ liệu';

  @override
  String get homeLoadFailedMessage =>
      'Kiểm tra kết nối tới máy chủ rồi thử lại.';

  @override
  String get homeRetryAction => 'Thử lại';

  @override
  String get homeEmptyTitle => 'Chưa có sản phẩm nào';

  @override
  String get homeEmptyMessage =>
      'Khi người bán ghi nhận độ tươi, sản phẩm sẽ hiện ở đây.';

  @override
  String get homeLocationUnknown => 'Bật vị trí';

  @override
  String get homeLocationSearching => 'Đang định vị…';

  @override
  String get homeLocationNearby => 'Gần bạn';

  @override
  String get homeLocationOffHint =>
      'Bật định vị để xem cửa hàng gần bạn trước.';

  @override
  String get homeLocationBlockedHint =>
      'Vào Cài đặt để cho phép ứng dụng dùng vị trí.';

  @override
  String get homeNoShopNearbyTitle => 'Chưa có cửa hàng gần bạn';

  @override
  String get homeNoShopNearbyMessage =>
      'Không tìm thấy cửa hàng nào trong bán kính 20 km.';

  @override
  String get mapLocatingTitle => 'Đang tìm vị trí của bạn';

  @override
  String get mapLocatingMessage => 'Bản đồ sẽ mở ngay tại chỗ bạn đang đứng.';

  @override
  String get mapLocationUnavailable =>
      'Chưa có vị trí của bạn — đang hiện các cửa hàng đã lưu.';

  @override
  String get homeOutsideRangeNotice =>
      'Không có cửa hàng nào trong 20 km. Đây là những cửa hàng gần bạn nhất.';

  @override
  String productDetailPostedAt(Object when) {
    return 'Đăng $when';
  }

  @override
  String productDetailSoldBy(Object shop) {
    return 'Bán bởi $shop';
  }

  @override
  String get productHistoryUnavailableTitle => 'Chưa đọc được lịch sử';

  @override
  String get productHistoryUnavailableBody =>
      'Không lấy được chuỗi ghi nhận của sản phẩm này. Kiểm tra kết nối rồi thử lại.';

  @override
  String get productHistoryTitle => 'Lịch sử thay đổi';

  @override
  String get productHistorySubtitle =>
      'Mỗi thay đổi được ký và móc xích bằng mã băm, không sửa lại được';

  @override
  String get productHistoryVerified => 'Chuỗi nguyên vẹn';

  @override
  String get productHistoryBroken => 'Chuỗi có dấu hiệu bị sửa';

  @override
  String productHistoryCopied(Object sha) {
    return 'Đã sao chép $sha';
  }

  @override
  String get productHistoryActionCreated => 'Tạo sản phẩm';

  @override
  String get productHistoryActionUpdated => 'Cập nhật';

  @override
  String get productHistoryActionDeleted => 'Gỡ khỏi quầy';

  @override
  String get productHistoryActionModerated => 'Kiểm duyệt';

  @override
  String get productHistoryEmpty => 'Chưa có thay đổi nào được ghi nhận.';

  @override
  String productPriceChartTitle(Object days) {
    return 'Giá $days ngày gần nhất';
  }

  @override
  String productPriceChartFlat(Object days) {
    return 'Giá không đổi trong $days ngày qua.';
  }

  @override
  String get productFieldPrice => 'Giá';

  @override
  String get productFieldName => 'Tên';

  @override
  String get productFieldDescription => 'Mô tả';

  @override
  String get productFieldCategory => 'Danh mục';

  @override
  String get productFieldFreshnessScore => 'Điểm độ tươi';

  @override
  String get productFieldFreshnessNote => 'Ghi chú độ tươi';

  @override
  String get productFieldStatus => 'Trạng thái';

  @override
  String get productFieldTags => 'Thẻ';

  @override
  String get productFieldImages => 'Số ảnh';

  @override
  String get productFieldCurrency => 'Đơn vị tiền';

  @override
  String get homeForYouTitle => 'Gợi ý cho bạn';

  @override
  String get homePopularTitle => 'Được quan tâm nhiều';

  @override
  String homeForYouBasis(Object count) {
    return 'Dựa trên $count hoạt động của bạn';
  }

  @override
  String get homePopularBasis =>
      'Bạn chưa có hoạt động nào — đây là những lựa chọn đang được tin tưởng nhất';

  @override
  String recommendReasonCategory(Object category) {
    return 'Hợp gu $category của bạn';
  }

  @override
  String get recommendReasonShopRated => 'Cửa hàng bạn từng đánh giá';

  @override
  String get recommendReasonNear => 'Gần bạn';

  @override
  String get recommendReasonTrust => 'Điểm tin cậy cao';

  @override
  String get recommendReasonRated => 'Được đánh giá tốt';

  @override
  String get marketPriceTitle => 'Giá trung bình thị trường';

  @override
  String marketPriceBasis(Object count) {
    return 'Trung bình từ $count cửa hàng cùng bán mặt hàng này';
  }

  @override
  String marketPriceCheaper(Object percent) {
    return 'Rẻ hơn trung bình $percent%';
  }

  @override
  String marketPriceDearer(Object percent) {
    return 'Cao hơn trung bình $percent%';
  }

  @override
  String get marketPriceInline => 'Ngang giá trung bình';

  @override
  String get marketPriceAverageLabel => 'Trung bình';

  @override
  String get marketPriceThisShopLabel => 'Cửa hàng này';

  @override
  String marketPriceRange(Object low, Object high) {
    return 'Thấp nhất $low · Cao nhất $high';
  }

  @override
  String get sellerDashboardNoShopTitle => 'Tài khoản này chưa có cửa hàng';

  @override
  String get sellerDashboardNoShopBody =>
      'Tạo cửa hàng trước, rồi mới thêm sản phẩm và ghi nhận được.';

  @override
  String get sellerDashboardNoShopAction => 'Tạo cửa hàng';

  @override
  String get sellerDashboardFailedTitle => 'Không tải được số liệu cửa hàng';

  @override
  String get sellerDashboardFailedBody => 'Kiểm tra kết nối rồi thử lại.';

  @override
  String get sellerShopSaveFailed =>
      'Không lưu được cửa hàng. Kiểm tra kết nối rồi thử lại.';

  @override
  String get sellerShopLoadFailedTitle => 'Không tải được thông tin cửa hàng';

  @override
  String get sellerShopStateActive => 'Đang hoạt động';

  @override
  String get sellerShopStateSuspended => 'Tạm ngưng';

  @override
  String get sellerShopStateDeleted => 'Đã xoá';

  @override
  String get sellerIntegrityLabel => 'Tính toàn vẹn';

  @override
  String homeOfferPercent(int value) {
    return 'Giảm $value%';
  }

  @override
  String homeOfferAmount(String value) {
    return 'Giảm $value';
  }

  @override
  String homeOfferMinSpend(String value) {
    return 'Đơn từ $value';
  }

  @override
  String homeOfferExpiry(String value) {
    return 'Đến $value';
  }

  @override
  String get homeOffersTitle => 'Ưu đãi đang có';

  @override
  String get homeRankedTitle => 'Gợi ý cho bạn';

  @override
  String get homeRankedPopularTitle => 'Sản phẩm được quan tâm';

  @override
  String get homeSpotlightTitle => 'Sản phẩm được quan tâm nhiều';

  @override
  String get homeFilterResults => 'Kết quả';

  @override
  String get homeFilterEmpty => 'Không có sản phẩm nào khớp.';

  @override
  String get accountMyChecks => 'Sản phẩm tôi đã kiểm tra';

  @override
  String get myChecksTitle => 'Sản phẩm tôi đã kiểm tra';

  @override
  String get myChecksEmptyTitle => 'Chưa kiểm tra sản phẩm nào';

  @override
  String get myChecksEmptyBody =>
      'Quét mã sản phẩm tại quầy và chụp ảnh đối chứng — mỗi lần kiểm tra sẽ được lưu vào đây.';

  @override
  String get myChecksEmptyAction => 'Quét sản phẩm';

  @override
  String get myChecksFailed => 'Không đọc được danh sách kiểm tra.';

  @override
  String myChecksScores(String pledged, String actual) {
    return 'Cam kết $pledged · Đo được $actual';
  }

  @override
  String get myChecksNoPledge => 'Không có cam kết để đối chiếu';

  @override
  String get commonProduct => 'Sản phẩm';

  @override
  String get accountMyActivity => 'Hoạt động của tôi';

  @override
  String get verdictTrusted => 'Khớp cam kết';

  @override
  String get verdictWarning => 'Lệch nhẹ';

  @override
  String get verdictHighRisk => 'Lệch nhiều';

  @override
  String get verdictNoPledge => 'Chưa có cam kết';

  @override
  String get verdictUnknown => 'Chưa rõ';
}
