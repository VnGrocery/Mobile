import 'package:flutter/foundation.dart';

import 'app_data_config.dart';

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

  String get displayName {
    final name = _displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return email.contains('@')
        ? email.split('@').first
        : (email.isEmpty ? 'User' : email);
  }

  void login({
    required String email,
    String? displayName,
    String role = 'user',
  }) {
    token = 'mock-token-${DateTime.now().millisecondsSinceEpoch}';
    shopId = role == 'seller' ? AppDataConfig.demoShopId : null;
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
      shopId ??= AppDataConfig.demoShopId;
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
