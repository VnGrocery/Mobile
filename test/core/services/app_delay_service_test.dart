import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/services/app_delay_service.dart';

void main() {
  group('AppDelayService', () {
    test('default durations stay stable', () {
      expect(
        AppDelayService.defaultDuration(AppDelayKind.scannerVerification),
        const Duration(milliseconds: 900),
      );
      expect(
        AppDelayService.defaultDuration(AppDelayKind.pledgeAnalysis),
        const Duration(milliseconds: 1500),
      );
      expect(
        AppDelayService.defaultDuration(AppDelayKind.pledgeCommit),
        const Duration(milliseconds: 900),
      );
      expect(
        AppDelayService.defaultDuration(AppDelayKind.productSave),
        const Duration(milliseconds: 900),
      );
      expect(
        AppDelayService.defaultDuration(AppDelayKind.reviewSubmit),
        const Duration(milliseconds: 900),
      );
      expect(
        AppDelayService.defaultDuration(AppDelayKind.voucherMarkUsed),
        const Duration(milliseconds: 450),
      );
      expect(
        AppDelayService.defaultDuration(AppDelayKind.authLogin),
        const Duration(milliseconds: 800),
      );
      expect(
        AppDelayService.defaultDuration(AppDelayKind.authRegister),
        const Duration(milliseconds: 600),
      );
      expect(
        AppDelayService.defaultDuration(AppDelayKind.passwordChange),
        const Duration(milliseconds: 650),
      );
      expect(
        AppDelayService.defaultDuration(AppDelayKind.freshnessAnalysis),
        const Duration(seconds: 2),
      );
      expect(
        AppDelayService.defaultDuration(AppDelayKind.splash),
        const Duration(seconds: 2),
      );
    });

    test('override wins', () async {
      final service = AppDelayService(
        overrides: {AppDelayKind.reviewSubmit: Duration.zero},
      );

      final stopwatch = Stopwatch()..start();
      await service.wait(AppDelayKind.reviewSubmit);
      stopwatch.stop();

      expect(stopwatch.elapsed, lessThan(const Duration(milliseconds: 100)));
    });

    test('noop waits complete immediately', () async {
      const service = NoopAppDelayService();

      final stopwatch = Stopwatch()..start();
      await service.wait(AppDelayKind.reviewSubmit);
      await service.waitDuration(const Duration(seconds: 1));
      stopwatch.stop();

      expect(stopwatch.elapsed, lessThan(const Duration(milliseconds: 100)));
    });
  });
}
