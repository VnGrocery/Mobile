import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vngrocery/main.dart' as app;

void main() {
  // These smoke tests require an Android/iOS integration-test device or emulator.
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  Future<void> launchAsBuyer(WidgetTester tester) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    final skip = find.text('Bỏ qua');
    if (skip.evaluate().isNotEmpty) {
      await tester.tap(skip);
      await tester.pumpAndSettle();
    }

    final google = find.text('Tiếp tục với Google');
    if (google.evaluate().isNotEmpty) {
      await tester.tap(google);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }
  }

  testWidgets(
    'buyer can launch, reach main navigation, and open scanner tab',
    (tester) async {
      await launchAsBuyer(tester);

      expect(find.text('Trang chủ'), findsWidgets);
      expect(find.text('Khám phá'), findsWidgets);
      expect(find.text('Cửa hàng'), findsWidgets);
      expect(find.text('Tài khoản'), findsWidgets);

      await tester.tap(find.bySemanticsLabel('Quét sản phẩm'));
      await tester.pumpAndSettle();

      expect(find.text('Camera Preview...'), findsOneWidget);
      expect(find.text('Giả lập quét sản phẩm'), findsOneWidget);
    },
    skip: defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS,
  );
}
