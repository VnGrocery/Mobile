import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/scanner/controllers/scanner_cubit.dart';

void main() {
  test('ScannerCubit verifies and completes simulated scan', () async {
    final cubit = ScannerCubit(simulateDelay: Duration.zero);

    await cubit.simulateScan();

    expect(cubit.state.completed, isTrue);
    expect(cubit.state.verifying, isFalse);

    cubit.close();
  });

  test('ScannerCubit can reset completion', () async {
    final cubit = ScannerCubit(simulateDelay: Duration.zero);

    await cubit.simulateScan();
    cubit.resetCompletion();

    expect(cubit.state.completed, isFalse);
    expect(cubit.state.verifying, isFalse);

    cubit.close();
  });
}
