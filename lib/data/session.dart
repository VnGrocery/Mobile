import 'package:flutter/foundation.dart';

import 'app_data_config.dart';
import 'package:vngrocery/core/storage/hive_storage_service.dart';
import 'package:vngrocery/data/api/auth_api.dart';

class SessionSnapshot {
  final String? token;
  final String? shopId;
  final String email;
  final String displayName;
  final String role;
  final String refreshToken;
  final String userId;
  final int version;

  const SessionSnapshot({
    required this.token,
    required this.shopId,
    required this.email,
    required this.displayName,
    required this.role,
    this.refreshToken = '',
    this.userId = '',
    this.version = 1,
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
    String? refreshToken,
    String? userId,
    int? version,
  }) {
    final nextEmail = email ?? this.email;
    final nextDisplayName = displayName ?? this.displayName;
    return SessionSnapshot(
      token: identical(token, _unset) ? this.token : token as String?,
      shopId: identical(shopId, _unset) ? this.shopId : shopId as String?,
      email: nextEmail,
      displayName: fallbackDisplayName(nextEmail, nextDisplayName),
      role: role ?? this.role,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
      version: version ?? this.version,
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
  AuthApi? _authApi;

  void configure(AuthApi authApi) => _authApi = authApi;

  bool get isLoggedIn => current.isLoggedIn;

  String get displayName => current.displayName;

  void login({
    required String email,
    String? displayName,
    String role = 'user',
  }) {
    final normalizedEmail = email.trim().isEmpty
        ? 'demo@vngrocery.com'
        : email.trim();
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

  Future<void> authenticate({
    required String email,
    required String password,
    required bool register,
    String displayName = '',
  }) async {
    final api = _authApi;
    if (api == null) {
      login(email: email, displayName: displayName);
      return;
    }
    final auth = register
        ? await api.register(email, password, displayName)
        : await api.login(email, password);
    _setAuth(auth);
    await _persist();
  }

  Future<void> authenticateGoogle(String idToken) async {
    final api = _authApi;
    if (api == null) {
      login(email: 'google.demo@vngrocery.com', displayName: 'Google Demo');
      return;
    }
    _setAuth(await api.google(idToken));
    await _persist();
  }

  void _setAuth(AuthSession auth) {
    _current.value = SessionSnapshot(
      token: auth.accessToken,
      refreshToken: auth.refreshToken,
      userId: auth.userId,
      shopId: null,
      email: auth.email,
      displayName: SessionSnapshot.fallbackDisplayName(
        auth.email,
        auth.displayName,
      ),
      role: auth.role,
      version: auth.version,
    );
  }

  Future<void> restore() async {
    final box = HiveStorageService.tryMetadataBox();
    if (box == null) return;
    final token = box.get('session_access_token') as String?;
    if (token == null || token.isEmpty) return;
    final storedShopId = box.get('session_shop_id') as String? ?? '';
    _current.value = SessionSnapshot(
      token: token,
      refreshToken: box.get('session_refresh_token') as String? ?? '',
      userId: box.get('session_user_id') as String? ?? '',
      shopId: storedShopId.isEmpty ? null : storedShopId,
      email: box.get('session_email') as String? ?? '',
      displayName: box.get('session_display_name') as String? ?? 'User',
      role: box.get('session_role') as String? ?? 'buyer',
      version: box.get('session_version') as int? ?? 1,
    );
  }

  Future<void> _persist() async {
    final box = HiveStorageService.tryMetadataBox();
    if (box == null) return;
    await box.putAll({
      'session_access_token': current.token ?? '',
      'session_refresh_token': current.refreshToken,
      'session_user_id': current.userId,
      'session_shop_id': current.shopId ?? '',
      'session_email': current.email,
      'session_display_name': current.displayName,
      'session_role': current.role,
      'session_version': current.version,
    });
  }

  Future<void> updateProfileRemote({required String displayName}) async {
    final api = _authApi;
    if (api == null) {
      updateProfile(displayName: displayName, email: current.email);
      return;
    }
    final json = await api.updateMe(
      version: current.version,
      displayName: displayName,
    );
    _current.value = current.copyWith(
      displayName: json['displayName']?.toString() ?? displayName,
      version: (json['version'] as num?)?.toInt() ?? current.version + 1,
    );
    await _persist();
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async => _authApi?.changePassword(currentPassword, newPassword);

  Future<String> forgotPassword(String email) async {
    final json = await _authApi?.forgotPassword(email);
    return json?['resetToken']?.toString() ?? '';
  }

  Future<void> resetPassword(String token, String newPassword) async =>
      _authApi?.resetPassword(token, newPassword);

  Future<void> logoutRemote() async {
    final refresh = current.refreshToken;
    if (refresh.isNotEmpty) {
      try {
        await _authApi?.logout(refresh);
      } catch (_) {}
    }
    logout();
  }

  Future<String?> refreshAccessToken() async {
    final api = _authApi;
    if (api == null || current.refreshToken.isEmpty) return null;
    try {
      final refreshed = await api.refresh(current.refreshToken);
      if (refreshed.accessToken.isEmpty) return null;
      _current.value = current.copyWith(
        token: refreshed.accessToken,
        refreshToken: refreshed.refreshToken.isEmpty
            ? current.refreshToken
            : refreshed.refreshToken,
      );
      await _persist();
      return refreshed.accessToken;
    } catch (_) {
      return null;
    }
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
      shopId: role == 'seller'
          ? (current.shopId ?? AppDataConfig.demoShopId)
          : null,
    );
  }

  void setShopId(String shopId) {
    _current.value = current.copyWith(shopId: shopId);
    _persist();
  }

  void logout() {
    _current.value = const SessionSnapshot(
      token: null,
      shopId: null,
      email: '',
      displayName: 'User',
      role: 'user',
    );
    final box = HiveStorageService.tryMetadataBox();
    if (box != null) {
      box.deleteAll([
        'session_access_token',
        'session_refresh_token',
        'session_user_id',
        'session_shop_id',
        'session_email',
        'session_display_name',
        'session_role',
        'session_version',
      ]);
    }
  }
}
