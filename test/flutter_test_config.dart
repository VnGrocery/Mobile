import 'dart:async';

import 'package:vngrocery/data/mock_data.dart';

/// Seeds the in-memory store before any test file runs.
///
/// [MockDb] used to load its fixture in its own constructor, which meant the
/// app started up holding invented shops and products. It now starts empty,
/// so the fixture is loaded here instead — the tests that exercise the offline
/// paths still need something to read.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  MockDb.instance.resetForTesting();
  await testMain();
}
