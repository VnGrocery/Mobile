import 'package:vngrocery/data/session.dart';

class SessionState {
  final String? token;
  final String? shopId;
  final String email;
  final String displayName;
  final String role;

  const SessionState({
    required this.token,
    required this.shopId,
    required this.email,
    required this.displayName,
    required this.role,
  });

  factory SessionState.fromManager(SessionManager session) {
    return SessionState(
      token: session.token,
      shopId: session.shopId,
      email: session.email,
      displayName: session.displayName,
      role: session.role,
    );
  }

  bool get isLoggedIn => token != null;

  bool get isSeller => role == 'seller';
}
