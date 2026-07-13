import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/session.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final SessionManager _session;

  SessionCubit({SessionManager? session})
    : _session = session ?? SessionManager.instance,
      super(
        SessionState.fromSnapshot((session ?? SessionManager.instance).current),
      );

  void login({
    required String email,
    String? displayName,
    String role = 'user',
  }) {
    _session.login(email: email, displayName: displayName, role: role);
    _emitCurrent();
  }

  Future<void> authenticate({
    required String email,
    required String password,
    required bool register,
    String displayName = '',
  }) async {
    await _session.authenticate(
      email: email,
      password: password,
      register: register,
      displayName: displayName,
    );
    _emitCurrent();
  }

  Future<void> authenticateGoogle(String idToken) async {
    await _session.authenticateGoogle(idToken);
    _emitCurrent();
  }

  void updateProfile({required String displayName, required String email}) {
    _session.updateProfile(displayName: displayName, email: email);
    _emitCurrent();
  }

  Future<void> updateProfileRemote({required String displayName}) async {
    await _session.updateProfileRemote(displayName: displayName);
    _emitCurrent();
  }

  void setRole(String role) {
    _session.setRole(role);
    _emitCurrent();
  }

  void setShopId(String shopId) {
    _session.setShopId(shopId);
    _emitCurrent();
  }

  void logout() {
    _session.logout();
    _emitCurrent();
  }

  Future<void> logoutRemote() async {
    await _session.logoutRemote();
    _emitCurrent();
  }

  void _emitCurrent() {
    emit(SessionState.fromSnapshot(_session.current));
  }
}
