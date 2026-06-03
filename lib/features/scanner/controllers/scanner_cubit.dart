import 'package:flutter_bloc/flutter_bloc.dart';

import 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  final Duration simulateDelay;

  ScannerCubit({
    this.simulateDelay = const Duration(milliseconds: 900),
  }) : super(const ScannerState());

  Future<void> simulateScan() async {
    if (state.verifying) return;
    emit(const ScannerState(verifying: true));
    await Future<void>.delayed(simulateDelay);
    emit(const ScannerState(completed: true));
  }

  void resetCompletion() {
    if (!state.completed) return;
    emit(const ScannerState());
  }
}
