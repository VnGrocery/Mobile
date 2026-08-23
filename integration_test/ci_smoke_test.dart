import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vngrocery/core/storage/hive_storage_service.dart';
import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/main.dart' as app;
import 'package:vngrocery/theme/theme_controller.dart';

/// The on-device smoke test CI can actually run.
///
/// app_smoke_test.dart enters through the Google sign-in button, so it needs a
/// Google account on the device, a reachable server and a real client id - a
/// hosted runner has none of the three, and every one of its tests fails there
/// for reasons that have nothing to do with the app. This one signs the session
/// in from the test side and never touches the network, so a red run means the
/// shell broke rather than that a host was down. Keep the other file for runs
/// against a live stack.
Future<void> _resetDeviceState() async {
  SessionManager.instance.logout();
  ThemeController.instance.setDark(false);
  await Hive.close();
  for (final boxName in [
    HiveStorageService.metadataBoxName,
    HiveStorageService.cartBoxName,
    HiveStorageService.productBoxName,
  ]) {
    try {
      await Hive.deleteBoxFromDisk(boxName);
    } catch (_) {
      // Nothing to delete on the first run.
    }
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Finder navTab(String key) => find.byKey(ValueKey('nav.tab.$key'));

  Future<void> pumpFor(WidgetTester tester, Duration duration) async {
    const step = Duration(milliseconds: 100);
    var elapsed = Duration.zero;
    while (elapsed < duration) {
      final remaining = duration - elapsed;
      final next = remaining < step ? remaining : step;
      await tester.pump(next);
      elapsed += next;
    }
  }

  /// Launches the app already signed in.
  ///
  /// The session is set before main() runs: restore() returns early when there
  /// is no token on disk, so it leaves this one alone and splash sends the app
  /// straight to the shell without an auth round trip.
  Future<void> launchSignedIn(WidgetTester tester) async {
    await _resetDeviceState();
    SessionManager.instance.login(
      email: 'ci@vngrocery.demo',
      displayName: 'CI',
    );
    await app.main();
    await tester.pump();
    await pumpFor(tester, const Duration(seconds: 3));
  }

  tearDown(_resetDeviceState);

  final onDevice =
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  testWidgets(
    'the app opens with no server reachable and lands on the buyer shell',
    (tester) async {
      await launchSignedIn(tester);

      // Nothing answers on the API port here. The shell still has to appear:
      // this app is used at market stalls on a weak connection, and a launch
      // that dies offline is the worst failure it has.
      expect(navTab('home'), findsOneWidget);
      expect(navTab('scan'), findsOneWidget);
      expect(navTab('stores'), findsOneWidget);
      expect(navTab('account'), findsOneWidget);
    },
    skip: !onDevice,
  );

  testWidgets(
    'the buyer tabs switch without a server',
    (tester) async {
      await launchSignedIn(tester);

      await tester.tap(navTab('stores'));
      await tester.pump();
      await pumpFor(tester, const Duration(milliseconds: 800));
      expect(find.byKey(const ValueKey('store_list')), findsOneWidget);

      await tester.tap(navTab('home'));
      await tester.pump();
      await pumpFor(tester, const Duration(milliseconds: 800));
      expect(find.byKey(const ValueKey('store_list')), findsNothing);
    },
    skip: !onDevice,
  );
}
