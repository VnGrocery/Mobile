import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vngrocery/core/storage/hive_storage_service.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/main.dart' as app;
import 'package:vngrocery/theme/theme_controller.dart';

void resetSessionState() {
  SessionManager.instance.logout();
  ThemeController.instance.setDark(false);
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

void main() {
  // These smoke tests require an Android/iOS integration-test device or emulator.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Finder navTab(String key) => find.byKey(ValueKey('nav.tab.$key'));

  Finder storeCard(String shopId) => find.byKey(ValueKey('store.card.$shopId'));

  Future<void> pumpSeconds(WidgetTester tester, int seconds) async {
    await pumpFor(tester, Duration(seconds: seconds));
  }

  Future<void> pumpMillis(WidgetTester tester, int milliseconds) async {
    await pumpFor(tester, Duration(milliseconds: milliseconds));
  }

  Future<void> resetHarnessState() async {
    await resetAppHarnessState();
  }

  tearDown(() async {
    await resetAppHarnessState();
  });

  Future<void> launchAsBuyer(WidgetTester tester) async {
    await resetHarnessState();
    await app.main();
    await tester.pump();
    await pumpSeconds(tester, 3);

    final skip = find.byKey(const ValueKey('onboarding.skip_button'));
    if (skip.evaluate().isNotEmpty) {
      await tester.tap(skip);
      await tester.pump();
      await pumpMillis(tester, 500);
    }

    final google = find.byKey(const ValueKey('auth.google_sign_in_button'));
    if (google.evaluate().isNotEmpty) {
      await tester.tap(google);
      await tester.pump();
      await pumpSeconds(tester, 2);
    }
  }

  testWidgets(
    'buyer can launch, reach main navigation, and open scanner tab',
    (tester) async {
      await launchAsBuyer(tester);

      expect(navTab('home'), findsOneWidget);
      expect(navTab('explore'), findsOneWidget);
      expect(navTab('stores'), findsOneWidget);
      expect(navTab('account'), findsOneWidget);

      await tester.tap(navTab('scan'));
      await tester.pump();
      await pumpMillis(tester, 500);

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

  testWidgets(
    'buyer can switch between stable bottom-nav tabs',
    (tester) async {
      await launchAsBuyer(tester);

      await tester.tap(navTab('explore'));
      await tester.pump();
      await pumpMillis(tester, 500);
      expect(find.byKey(const ValueKey('explore_map')), findsOneWidget);

      await tester.tap(navTab('stores'));
      await tester.pump();
      await pumpMillis(tester, 500);
      expect(find.byKey(const ValueKey('store_list')), findsOneWidget);

      await tester.tap(navTab('home'));
      await tester.pump();
      await pumpMillis(tester, 500);
      expect(find.byKey(const ValueKey('explore_map')), findsNothing);
      expect(find.byKey(const ValueKey('store_list')), findsNothing);
    },
    skip:
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS,
  );

  testWidgets(
    'buyer can open a store from the store list',
    (tester) async {
      await launchAsBuyer(tester);

      await tester.tap(navTab('stores'));
      await tester.pump();
      await pumpMillis(tester, 500);
      await tester.tap(storeCard('s1'));
      await tester.pump();
      await pumpMillis(tester, 500);

      expect(find.byKey(const ValueKey('store_detail.s1')), findsOneWidget);
    },
    skip:
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS,
  );

  testWidgets(
    'buyer auth entry reaches main shell and can logout',
    (tester) async {
      await launchAsBuyer(tester);

      await tester.tap(navTab('account'));
      await tester.pump();
      await pumpMillis(tester, 500);

      await tester.tap(find.byKey(const ValueKey('account.logout_button')));
      await tester.pump();
      await pumpMillis(tester, 200);

      expect(find.text('Bạn có chắc muốn đăng xuất?'), findsOneWidget);
      await tester.tap(find.text('Đăng xuất').last);
      await tester.pump();
      await pumpSeconds(tester, 1);

      expect(find.byKey(const ValueKey('auth.google_sign_in_button')), findsOneWidget);
    },
    skip:
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS,
  );
}
