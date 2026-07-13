import 'package:vngrocery/core/network/api_client.dart';

class AuthSession {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String email;
  final String displayName;
  final String role;
  final int version;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
    required this.displayName,
    required this.role,
    this.version = 1,
  });

  factory AuthSession.fromJson(Map<String, Object?> json) => AuthSession(
    accessToken: json['accessToken']?.toString() ?? '',
    refreshToken: json['refreshToken']?.toString() ?? '',
    userId: json['userId']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    displayName: json['displayName']?.toString() ?? '',
    role: json['role']?.toString() ?? 'buyer',
    version: (json['version'] as num?)?.toInt() ?? 1,
  );
}

class AuthApi {
  const AuthApi(this._client);
  final ApiClient _client;

  Future<AuthSession> login(String email, String password) async =>
      AuthSession.fromJson(
        await _client.post(
          '/v1/auth/login',
          body: {'email': email.trim(), 'password': password},
        ),
      );

  Future<AuthSession> register(
    String email,
    String password,
    String displayName,
  ) async => AuthSession.fromJson(
    await _client.post(
      '/v1/auth/register',
      body: {
        'email': email.trim(),
        'password': password,
        'displayName': displayName.trim(),
      },
    ),
  );

  Future<AuthSession> google(String idToken) async => AuthSession.fromJson(
    await _client.post('/v1/auth/google', body: {'idToken': idToken}),
  );

  Future<AuthSession> refresh(String refreshToken) async =>
      AuthSession.fromJson(
        await _client.post(
          '/v1/auth/refresh',
          body: {'refreshToken': refreshToken},
          retryUnauthorized: false,
        ),
      );

  Future<void> logout(String refreshToken) =>
      _client.post('/v1/auth/logout', body: {'refreshToken': refreshToken});

  Future<Map<String, Object?>> me() => _client.get('/v1/me');

  Future<Map<String, Object?>> updateMe({
    required int version,
    required String displayName,
  }) => _client.patch(
    '/v1/me',
    body: {'expectedVersion': version, 'displayName': displayName},
  );

  Future<void> changePassword(String currentPassword, String newPassword) =>
      _client.post(
        '/v1/me/password',
        body: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );

  Future<Map<String, Object?>> forgotPassword(String email) =>
      _client.post('/v1/auth/password/forgot', body: {'email': email.trim()});

  Future<void> resetPassword(String resetToken, String newPassword) =>
      _client.post(
        '/v1/auth/password/reset',
        body: {'resetToken': resetToken, 'newPassword': newPassword},
      );
}
