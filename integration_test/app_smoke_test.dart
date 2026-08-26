import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vngrocery/core/storage/hive_storage_service.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/features/auth/widgets/auth_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
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
  Finder sideMenuRoute(String key) =>
      find.byKey(ValueKey('account.route.$key'));
  Finder sideMenuOpenHandle() =>
      find.byKey(const ValueKey('navigation.menu_open_handle'));
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

  /// Signs in with the email form against the live stack.
  ///
  /// The Google button is hidden on iOS - the plugin aborts the process with
  /// no GIDClientID - so the email path is the only way in there, and it is
  /// the one a demo account uses anyway.
  Future<void> launchAsDemoBuyer(WidgetTester tester) async {
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

    await tester.enterText(
      find.byKey(const ValueKey('auth.email_field')),
      'buyer1.241188@vngrocery.demo',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth.password_field')),
      'Passw0rd!',
    );
    await tester.pump();
    await tester.tap(find.byType(AuthSubmitButton));
    await tester.pump();
    await pumpSeconds(tester, 4);
  }

  testWidgets(
    'the activity history shows this account\'s own signed entries',
    (tester) async {
      await launchAsDemoBuyer(tester);
      final l10n = await AppLocalizations.delegate.load(const Locale('vi'));

      await tester.tap(navTab('account'));
      await tester.pump();
      await pumpMillis(tester, 800);

      final entry = find.byKey(
        const ValueKey('account.activity_history_button'),
      );
      await tester.scrollUntilVisible(entry, 200, maxScrolls: 20);
      await tester.tap(entry);
      await tester.pump();
      await pumpSeconds(tester, 4);

      expect(find.byKey(const ValueKey('activity_history')), findsOneWidget);
      // A trail that failed to load or came back empty would pass any check
      // that only looked for the screen.
      expect(find.text(l10n.activityFailed), findsNothing);
      expect(find.text(l10n.activityEmptyTitle), findsNothing);
      expect(find.text(l10n.activityVerifyAction), findsWidgets);

      await tester.tap(find.text(l10n.activityVerifyAction).first);
      await tester.pump();
      await pumpSeconds(tester, 4);

      // The server re-hashes the row and re-checks the signature; a broken one
      // would read as tampered instead.
      expect(find.text(l10n.activityVerifiedOk), findsWidgets);
    },
    skip:
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS,
  );

  testWidgets(
    'buyer can launch, reach main navigation, and open scanner tab',
    (tester) async {
      await launchAsDemoBuyer(tester);

      expect(navTab('home'), findsOneWidget);
      expect(navTab('scan'), findsOneWidget);
      expect(navTab('stores'), findsOneWidget);
      expect(navTab('account'), findsOneWidget);

      await tester.tap(navTab('scan'));
      await tester.pump();
      await pumpMillis(tester, 500);

      expect(find.byKey(const ValueKey('scanner.screen')), findsOneWidget);
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
      await launchAsDemoBuyer(tester);

      await tester.tap(navTab('stores'));
      await tester.pump();
      await pumpMillis(tester, 500);
      expect(find.byKey(const ValueKey('store_list')), findsOneWidget);

      await tester.tap(navTab('home'));
      await tester.pump();
      await pumpMillis(tester, 500);
      expect(find.byKey(const ValueKey('store_list')), findsNothing);
    },
    skip:
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS,
  );

  testWidgets(
    'buyer can open a store from the store list',
    (tester) async {
      await launchAsDemoBuyer(tester);

      await tester.tap(navTab('stores'));
      await tester.pump();
      await pumpMillis(tester, 500);
      // The live stack serves real shop ids, so the first card is the only
      // thing this test can name.
      final card = find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey<String> &&
            (w.key as ValueKey<String>).value.startsWith('store.card.'),
      );
      expect(card, findsWidgets);
      await tester.tap(card.first);
      await tester.pump();
      await pumpMillis(tester, 500);

      expect(
        find.byWidgetPredicate(
          (w) =>
              w.key is ValueKey<String> &&
              (w.key as ValueKey<String>).value.startsWith('store_detail.'),
        ),
        findsOneWidget,
      );
    },
    skip:
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS,
  );

  testWidgets(
    'buyer can open voucher wallet from side menu and add manual voucher',
    (tester) async {
      await launchAsDemoBuyer(tester);

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

      // Scanning needs a real camera the simulator does not have, and
      // QrScanScreen never returns without one -- it would sit on top of this
      // form forever. The code field takes typed input just as well.
      expect(manualVoucherScanQrButton(), findsOneWidget);
      expect(manualVoucherCodeField(), findsOneWidget);
      await tester.enterText(manualVoucherCodeField(), 'SMOKETEST123');
      await tester.enterText(manualVoucherTitleField(), 'Voucher smoke test');
      await tester.enterText(
        manualVoucherNoteField(),
        'Lưu từ integration smoke',
      );
      await tester.tap(manualVoucherSaveButton());
      await tester.pump();
      await pumpMillis(tester, 500);

      // The live server assigns the id, so only a predicate on the key prefix
      // survives a real save -- 'g2001' was a fixture id from the mock path.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w.key is ValueKey<String> &&
              (w.key as ValueKey<String>).value.startsWith(
                'voucher_wallet.card.',
              ),
        ),
        findsWidgets,
      );
      expect(voucherWalletEmptyState(), findsNothing);
      await tester.tap(voucherWalletShowUsedFilter());
      await tester.pump();
      await pumpMillis(tester, 200);
      expect(voucherWalletSummaryCard(), findsOneWidget);
    },
    skip:
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS,
  );

  testWidgets(
    'buyer auth entry reaches main shell and can logout',
    (tester) async {
      await launchAsDemoBuyer(tester);

      await tester.tap(navTab('account'));
      await tester.pump();
      await pumpMillis(tester, 500);

      // The button sits in a ListView below the fold on a short screen.
      await tester.scrollUntilVisible(
        accountLogoutButton(),
        200,
        maxScrolls: 20,
      );
      await tester.tap(accountLogoutButton());
      await tester.pump();
      await pumpMillis(tester, 200);

      expect(accountLogoutConfirmButton(), findsOneWidget);
      await tester.tap(accountLogoutConfirmButton());
      await tester.pump();
      await pumpSeconds(tester, 1);

      // Not the Google button: it is hidden on iOS, so the email field is the
      // key both platforms actually show back on the auth screen.
      expect(find.byKey(const ValueKey('auth.email_field')), findsOneWidget);
    },
    skip:
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS,
  );
}
