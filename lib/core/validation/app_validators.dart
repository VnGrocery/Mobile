class AppValidators {
  const AppValidators._();

  static String? email(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Nhập email';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!ok) return 'Email không hợp lệ';
    return null;
  }

  static String? displayName(String? value) {
    final name = (value ?? '').trim();
    if (name.length < 2) {
      return 'Nhập tên hiển thị tối thiểu 2 ký tự';
    }
    return null;
  }

  static String? password(String? value, {required bool register}) {
    if ((value ?? '').length < (register ? 8 : 1)) {
      return register ? 'Mật khẩu tối thiểu 8 ký tự' : 'Nhập mật khẩu';
    }
    return null;
  }

  static String? newPassword(String? value) {
    if ((value ?? '').length < 8) {
      return 'Mật khẩu mới tối thiểu 8 ký tự';
    }
    return null;
  }

  static String? currentPassword(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Nhập mật khẩu hiện tại';
    }
    return null;
  }

  static String? passwordChange({
    required String currentPassword,
    required String newPassword,
  }) {
    if (newPassword == currentPassword) {
      return 'Mật khẩu mới phải khác mật khẩu hiện tại';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if ((value ?? '') != password) {
      return 'Mật khẩu nhập lại chưa khớp';
    }
    return null;
  }

  static int passwordStrength(String password) {
    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    return score.clamp(0, 4);
  }
}
