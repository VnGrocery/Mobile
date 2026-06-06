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
    return SessionState.fromSnapshot(session.current);
  }

  factory SessionState.fromSnapshot(SessionSnapshot snapshot) {
    return SessionState(
      token: snapshot.token,
      shopId: snapshot.shopId,
      email: snapshot.email,
      displayName: snapshot.displayName,
      role: snapshot.role,
    );
  }

  bool get isLoggedIn => token != null;

  bool get isSeller => role == 'seller';
}
