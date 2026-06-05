import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vngrocery/core/storage/hive_storage_service.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/main.dart' as app;
import 'package:vngrocery/theme/theme_controller.dart';

void main() {
  // These smoke tests require an Android/iOS integration-test device or emulator.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> resetHarnessState() async {
    SessionManager.instance.logout();
    ThemeController.instance.setDark(false);
    MockDb.instance.resetForTesting();
    await Hive.close();
    for (final boxName in [
      HiveStorageService.metadataBoxName,
      HiveStorageService.cartBoxName,
      HiveStorageService.productBoxName,
    ]) {
      try {
        await Hive.deleteBoxFromDisk(boxName);
      } catch (_) {
        // Box may not exist on first run.
      }
    }
  }

  Future<void> launchAsBuyer(WidgetTester tester) async {
    await resetHarnessState();
    await app.main();
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    final skip = find.text('Bỏ qua');
    if (skip.evaluate().isNotEmpty) {
      await tester.tap(skip);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    final google = find.text('Tiếp tục với Google');
    if (google.evaluate().isNotEmpty) {
      await tester.tap(google);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
    }
  }

  tearDown(() async {
    SessionManager.instance.logout();
    ThemeController.instance.setDark(false);
    await Hive.close();
  });

  testWidgets(
    'buyer can launch, reach main navigation, and open scanner tab',
    (tester) async {
      await launchAsBuyer(tester);

      expect(find.text('Trang chủ'), findsWidgets);
      expect(find.text('Khám phá'), findsWidgets);
      expect(find.text('Cửa hàng'), findsWidgets);
      expect(find.text('Tài khoản'), findsWidgets);

      await tester.tap(find.bySemanticsLabel('Quét sản phẩm'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.byKey(const ValueKey('scanner.camera_preview')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('scanner.simulate_scan_button')),
        findsOneWidget,
      );
    },
    skip:
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS,
  );
}
