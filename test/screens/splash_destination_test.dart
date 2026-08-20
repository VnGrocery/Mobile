import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vngrocery/core/storage/hive_storage_service.dart';

/// The startup flow used to walk every launch through the intro and then the
/// login form, even for a signed-in user. These pin the two pieces of state
/// that decide where splash goes.
void main() {
  setUp(() async {
    Hive.init('.dart_tool/test_hive_${DateTime.now().microsecondsSinceEpoch}');
    await Hive.openBox<Object>(HiveStorageService.metadataBoxName);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  test('onboarding is unseen on a fresh install', () {
    expect(HiveStorageService.onboardingSeen, isFalse);
  });

  test('onboarding stays seen once marked', () async {
    await HiveStorageService.markOnboardingSeen();
    expect(HiveStorageService.onboardingSeen, isTrue);
  });

  test('marking is idempotent', () async {
    await HiveStorageService.markOnboardingSeen();
    await HiveStorageService.markOnboardingSeen();
    expect(HiveStorageService.onboardingSeen, isTrue);
  });
}
