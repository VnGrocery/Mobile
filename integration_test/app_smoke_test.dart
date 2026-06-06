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
  Finder sideMenuRoute(String key) => find.byKey(ValueKey('account.route.$key'));
  Finder sideMenuOpenHandle() =>
      find.byKey(const ValueKey('navigation.menu_open_handle'));
  Finder sideMenuCloseOverlay() =>
      find.byKey(const ValueKey('navigation.menu_close_overlay'));
  Finder storeCard(String shopId) => find.byKey(ValueKey('store.card.$shopId'));
  Finder voucherWalletCard(String userVoucherId) =>
      find.byKey(ValueKey('voucher_wallet.card.$userVoucherId'));
  Finder voucherWalletAddManualButton() =>
      find.byKey(const ValueKey('voucher_wallet.add_manual_button'));
  Finder manualVoucherTitleField() =>
      find.byKey(const ValueKey('manual_voucher.title_field'));
  Finder manualVoucherNoteField() =>
      find.byKey(const ValueKey('manual_voucher.note_field'));
  Finder manualVoucherCodeField() =>
      find.byKey(const ValueKey('manual_voucher.code_field'));
  Finder accountLogoutButton() =>
      find.byKey(const ValueKey('account.logout_button'));
  Finder accountLogoutConfirmButton() =>
      find.byKey(const ValueKey('account.logout_dialog.confirm_button'));

  Finder manualVoucherScanQrButton() =>
      find.byKey(const ValueKey('manual_voucher.scan_qr_button'));
  Finder manualVoucherSaveButton() =>
      find.byKey(const ValueKey('manual_voucher.save_button'));
  Finder voucherWalletSummaryCard() =>
      find.byKey(const ValueKey('voucher_wallet.summary_card'));
  Finder voucherWalletShowUsedFilter() =>
      find.byKey(const ValueKey('voucher_wallet.show_used_filter'));
  Finder voucherWalletEmptyState() =>
      find.byKey(const ValueKey('voucher_wallet.empty_state'));


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
    'buyer can open voucher wallet from side menu and add manual voucher',
    (tester) async {
      await launchAsBuyer(tester);

      await tester.drag(sideMenuOpenHandle(), const Offset(80, 0));
      await tester.pump();
      await pumpMillis(tester, 500);

      expect(sideMenuRoute('wallet'), findsOneWidget);
      await tester.tap(sideMenuRoute('wallet'));
      await tester.pump();
      await pumpMillis(tester, 500);

      expect(voucherWalletSummaryCard(), findsOneWidget);
      await tester.tap(voucherWalletAddManualButton());
      await tester.pump();
      await pumpMillis(tester, 500);

      expect(manualVoucherScanQrButton(), findsOneWidget);
      expect(manualVoucherCodeField(), findsOneWidget);
      await tester.tap(manualVoucherScanQrButton());
      await tester.pump();
      await pumpMillis(tester, 200);

      await tester.enterText(
        manualVoucherTitleField(),
        'Voucher smoke test',
      );
      await tester.enterText(
        manualVoucherNoteField(),
        'Lưu từ integration smoke',
      );
      await tester.tap(manualVoucherSaveButton());
      await tester.pump();
      await pumpMillis(tester, 500);

      expect(voucherWalletCard('g2001'), findsOneWidget);
      expect(voucherWalletEmptyState(), findsNothing);
      await tester.tap(voucherWalletShowUsedFilter());
      await tester.pump();
      await pumpMillis(tester, 200);
      expect(voucherWalletSummaryCard(), findsOneWidget);

      await tester.drag(sideMenuOpenHandle(), const Offset(80, 0));
      await tester.pump();
      await pumpMillis(tester, 500);
      expect(sideMenuCloseOverlay(), findsOneWidget);
      await tester.tap(sideMenuCloseOverlay());
      await tester.pump();
      await pumpMillis(tester, 200);
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

      await tester.tap(accountLogoutButton());
      await tester.pump();
      await pumpMillis(tester, 200);

      expect(accountLogoutConfirmButton(), findsOneWidget);
      await tester.tap(accountLogoutConfirmButton());
      await tester.pump();
      await pumpSeconds(tester, 1);

      expect(find.byKey(const ValueKey('auth.google_sign_in_button')), findsOneWidget);
    },
    skip:
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS,
  );
}
