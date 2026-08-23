import 'package:vngrocery/data/session.dart';

class SessionState {
  final String? token;
  final String? shopId;
  final String email;
  final String displayName;
  final String role;
  final bool sellerMode;
  final int version;

  const SessionState({
    required this.token,
    required this.shopId,
    required this.email,
    required this.displayName,
    required this.role,
    this.sellerMode = false,
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
      sellerMode: snapshot.sellerMode,
      version: snapshot.version,
    );
  }

  bool get isLoggedIn => token != null;

  /// Whether an admin has approved this account to sell.
  bool get canSell => role == 'seller' || role == 'admin';

  /// Whether the seller side is on screen. Distinct from [canSell]: one is a
  /// permission the server granted, the other is a switch on this phone.
  bool get isSeller => canSell && sellerMode;
}
