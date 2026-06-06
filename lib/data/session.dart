import 'package:flutter/foundation.dart';

import 'app_data_config.dart';

class SessionSnapshot {
  final String? token;
  final String? shopId;
  final String email;
  final String displayName;
  final String role;

  const SessionSnapshot({
    required this.token,
    required this.shopId,
    required this.email,
    required this.displayName,
    required this.role,
  });

  bool get isLoggedIn => token != null;

  bool get isSeller => role == 'seller';

  static String fallbackDisplayName(String email, String? displayName) {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return email.contains('@')
        ? email.split('@').first
        : (email.isEmpty ? 'User' : email);
  }

  SessionSnapshot copyWith({
    Object? token = _unset,
    Object? shopId = _unset,
    String? email,
    String? displayName,
    String? role,
  }) {
    final nextEmail = email ?? this.email;
    final nextDisplayName = displayName ?? this.displayName;
    return SessionSnapshot(
      token: identical(token, _unset) ? this.token : token as String?,
      shopId: identical(shopId, _unset) ? this.shopId : shopId as String?,
      email: nextEmail,
      displayName: fallbackDisplayName(nextEmail, nextDisplayName),
      role: role ?? this.role,
    );
  }
}

const _unset = Object();

class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  final ValueNotifier<SessionSnapshot> _current = ValueNotifier(
    const SessionSnapshot(
      token: null,
      shopId: null,
      email: '',
      displayName: 'User',
      role: 'user',
    ),
  );

  ValueListenable<SessionSnapshot> get currentListenable => _current;

  SessionSnapshot get current => _current.value;

  String? get token => current.token;

  String? get shopId => current.shopId;

  String get email => current.email;

  String get role => current.role;

  bool get isLoggedIn => current.isLoggedIn;

  String get displayName => current.displayName;

  void login({
    required String email,
    String? displayName,
    String role = 'user',
  }) {
    final normalizedEmail = email.trim().isEmpty ? 'demo@vngrocery.com' : email.trim();
    final normalizedDisplayName = SessionSnapshot.fallbackDisplayName(
      normalizedEmail,
      displayName,
    );
    _current.value = SessionSnapshot(
      token: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
      shopId: role == 'seller' ? AppDataConfig.demoShopId : null,
      email: normalizedEmail,
      displayName: normalizedDisplayName,
      role: role,
    );
  }

  void updateProfile({required String displayName, required String email}) {
    final nextEmail = email.trim().isEmpty ? current.email : email.trim();
    _current.value = current.copyWith(
      email: nextEmail,
      displayName: displayName.trim(),
    );
  }

  void setRole(String role) {
    if (current.role == role) return;
    _current.value = current.copyWith(
      role: role,
      shopId: role == 'seller' ? (current.shopId ?? AppDataConfig.demoShopId) : null,
    );
  }

  void setShopId(String shopId) {
    _current.value = current.copyWith(shopId: shopId);
  }

  void logout() {
    _current.value = const SessionSnapshot(
      token: null,
      shopId: null,
      email: '',
      displayName: 'User',
      role: 'user',
    );
  }
}
