import 'package:vngrocery/data/session.dart';

class SessionState {
  final String? token;
  final String? shopId;
  final String email;
  final String displayName;
  final String role;
  final int version;

  const SessionState({
    required this.token,
    required this.shopId,
    required this.email,
    required this.displayName,
    required this.role,
    this.version = 1,
  });

  factory SessionState.fromManager(SessionManager session) {
    return SessionState.fromSnapshot(session.current);
  }

  factory SessionState.fromSnapshot(SessionSnapshot snapshot) {
    return SessionState(
      token: snapshot.token,
      shopId: snapshot.shopId,
      email: snapshot.email,
      displayName: snapshot.displayName,
      role: snapshot.role,
      version: snapshot.version,
    );
  }

  bool get isLoggedIn => token != null;

  bool get isSeller => role == 'seller';
}
