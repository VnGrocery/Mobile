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
}
