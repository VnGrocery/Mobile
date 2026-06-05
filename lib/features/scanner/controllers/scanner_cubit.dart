import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  final AppDelayService _delayService;

  ScannerCubit({AppDelayService delayService = AppDelayService.instance})
    : _delayService = delayService,
      super(const ScannerState());

  Future<void> simulateScan() async {
    if (state.verifying) return;
    emit(const ScannerState(verifying: true));
    await _delayService.wait(AppDelayKind.scannerVerification);
    emit(const ScannerState(completed: true));
  }

  void resetCompletion() {
    if (!state.completed) return;
    emit(const ScannerState());
  }
}
