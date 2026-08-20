enum AppDelayKind {
  pledgeAnalysis,
  pledgeCommit,
  productSave,
  voucherMarkUsed,
  authLogin,
  authRegister,
  passwordChange,
  freshnessAnalysis,
  splash,
}

class AppDelayService {
  const AppDelayService({this.overrides = const {}});

  static const instance = AppDelayService();

  final Map<AppDelayKind, Duration> overrides;

  Future<void> wait(AppDelayKind kind) {
    final duration = overrides[kind] ?? defaultDuration(kind);
    return waitDuration(duration);
  }

  Future<void> waitDuration(Duration duration) {
    return Future<void>.delayed(duration);
  }

  static Duration defaultDuration(AppDelayKind kind) {
    switch (kind) {
      case AppDelayKind.pledgeAnalysis:
        return const Duration(milliseconds: 1500);
      case AppDelayKind.pledgeCommit:
        return const Duration(milliseconds: 900);
      case AppDelayKind.productSave:
        return const Duration(milliseconds: 900);
      case AppDelayKind.voucherMarkUsed:
        return const Duration(milliseconds: 450);
      case AppDelayKind.authLogin:
        return const Duration(milliseconds: 800);
      case AppDelayKind.authRegister:
        return const Duration(milliseconds: 600);
      case AppDelayKind.passwordChange:
        return const Duration(milliseconds: 650);
      case AppDelayKind.freshnessAnalysis:
        return const Duration(seconds: 2);
      case AppDelayKind.splash:
        return const Duration(seconds: 2);
    }
  }
}

class NoopAppDelayService extends AppDelayService {
  const NoopAppDelayService();

  @override
  Future<void> wait(AppDelayKind kind) async {}

  @override
  Future<void> waitDuration(Duration duration) async {}
}
