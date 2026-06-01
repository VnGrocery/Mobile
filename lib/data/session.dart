import 'package:flutter/foundation.dart';

import 'mock_data.dart';

/// Quản lý phiên đăng nhập giả lập (tương ứng SessionManager.kt).
class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  String? token;
  String? shopId;
  String email = '';
  final ValueNotifier<String> roleNotifier = ValueNotifier<String>('user');

  String get role => roleNotifier.value;

  bool get isLoggedIn => token != null;

  /// Tên hiển thị = phần trước '@' của email (giống AccountScreen.kt).
  String get displayName =>
      email.contains('@') ? email.split('@').first : (email.isEmpty ? 'User' : email);

  /// Đăng nhập giả: chấp nhận mọi email/mật khẩu. Gán shopId demo để
  /// các luồng seller (seller_products/{shopId}) hoạt động.
  void login({required String email, String? displayName, String role = 'seller'}) {
    token = 'mock-token-${DateTime.now().millisecondsSinceEpoch}';
    shopId = MockDb.demoShopId;
    this.email = email.trim().isEmpty ? 'demo@vngrocery.com' : email.trim();
    roleNotifier.value = role;
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
    roleNotifier.value = 'user';
  }
}
