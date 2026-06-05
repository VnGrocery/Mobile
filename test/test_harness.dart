import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vngrocery/core/storage/hive_storage_service.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/theme/theme_controller.dart';

void resetSessionState() {
  SessionManager.instance.logout();
  ThemeController.instance.setDark(false);
}

void addMockDbResetTearDown() {
  addTearDown(MockDb.instance.resetForTesting);
}

Future<void> resetAppHarnessState() async {
  resetSessionState();
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

void addWidgetHarnessTearDown() {
  addTearDown(() async {
    resetSessionState();
    await Hive.close();
  });
}

Future<void> pumpFor(
  WidgetTester tester,
  Duration duration, {
  Duration step = const Duration(milliseconds: 100),
}) async {
  var elapsed = Duration.zero;
  while (elapsed < duration) {
    final remaining = duration - elapsed;
    final next = remaining < step ? remaining : step;
    await tester.pump(next);
    elapsed += next;
  }
}
