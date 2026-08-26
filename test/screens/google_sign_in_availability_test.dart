import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/screens/auth_screen.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('iOS is not offered a button that aborts the process', () {
    // The iOS plugin throws an Objective-C exception with no GIDClientID, and
    // that kills the app rather than raising something Dart can catch.
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(googleSignInAvailable, isFalse);
  });

  test('Android keeps the button it has always had', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(googleSignInAvailable, isTrue);
  });
}
