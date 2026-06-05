import 'package:flutter/foundation.dart';

import 'app_data_config.dart';

class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  String? _token;
  String? _shopId;
  String _email = '';
  String? _displayName;
  final ValueNotifier<String> _roleNotifier = ValueNotifier<String>('user');

  ValueListenable<String> get roleListenable => _roleNotifier;

  @Deprecated('Use roleListenable; mutate through setRole/login/logout.')
  ValueListenable<String> get roleNotifier => _roleNotifier;

  String? get token => _token;

  String? get shopId => _shopId;

  String get email => _email;

  String get role => _roleNotifier.value;

  bool get isLoggedIn => _token != null;

  String get displayName {
    final name = _displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return _email.contains('@')
        ? _email.split('@').first
        : (_email.isEmpty ? 'User' : _email);
  }

  void login({
    required String email,
    String? displayName,
    String role = 'user',
  }) {
    _token = 'mock-token-${DateTime.now().millisecondsSinceEpoch}';
    _shopId = role == 'seller' ? AppDataConfig.demoShopId : null;
    _email = email.trim().isEmpty ? 'demo@vngrocery.com' : email.trim();
    _displayName = displayName?.trim();
    _roleNotifier.value = role;
  }

  void updateProfile({required String displayName, required String email}) {
    _displayName = displayName.trim();
    _email = email.trim().isEmpty ? _email : email.trim();
  }

  void setRole(String role) {
    if (_roleNotifier.value == role) return;
    _roleNotifier.value = role;
    if (role == 'seller') {
      _shopId ??= AppDataConfig.demoShopId;
    } else {
      _shopId = null;
    }
  }

  void setShopId(String shopId) {
    _shopId = shopId;
  }

  void logout() {
    _token = null;
    _shopId = null;
    _email = '';
    _displayName = null;
    _roleNotifier.value = 'user';
  }
}
