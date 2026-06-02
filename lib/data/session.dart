import 'package:flutter/foundation.dart';

import 'mock_data.dart';

/// Quản lý phiên đăng nhập giả lập (tương ứng SessionManager.kt).
class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  String? token;
  String? shopId;
  String email = '';
  String? _displayName;
  final ValueNotifier<String> roleNotifier = ValueNotifier<String>('user');

  String get role => roleNotifier.value;

  bool get isLoggedIn => token != null;

  /// Tên hiển thị = phần trước '@' của email (giống AccountScreen.kt).
  String get displayName {
    final name = _displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return email.contains('@')
        ? email.split('@').first
        : (email.isEmpty ? 'User' : email);
  }

  /// Đăng nhập giả: chấp nhận mọi email/mật khẩu. Gán shopId demo để
  /// các luồng seller (seller_products/{shopId}) hoạt động.
  void login(
      {required String email, String? displayName, String role = 'user'}) {
    token = 'mock-token-${DateTime.now().millisecondsSinceEpoch}';
    shopId = role == 'seller' ? MockDb.demoShopId : null;
    this.email = email.trim().isEmpty ? 'demo@vngrocery.com' : email.trim();
    _displayName = displayName?.trim();
    roleNotifier.value = role;
  }

  void updateProfile({required String displayName, required String email}) {
    _displayName = displayName.trim();
    this.email = email.trim().isEmpty ? this.email : email.trim();
  }

  void setRole(String role) {
    if (roleNotifier.value == role) return;
    roleNotifier.value = role;
    if (role == 'seller') {
      shopId ??= MockDb.demoShopId;
    }
  }

  void logout() {
    token = null;
    shopId = null;
    email = '';
    _displayName = null;
    roleNotifier.value = 'user';
  }
}
