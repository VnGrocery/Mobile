import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/scanner/controllers/scanner_cubit.dart';
import 'package:vngrocery/features/scanner/controllers/scanner_state.dart';
import 'package:vngrocery/features/scanner/widgets/scanner_components.dart';
import 'package:vngrocery/routes/app_routes.dart';

class ScannerScreen extends StatefulWidget {
  final double bottomContentInset;

  const ScannerScreen({super.key, this.bottomContentInset = 0});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _line;
  late final ScannerCubit _scannerCubit;

  @override
  void initState() {
    super.initState();
    _scannerCubit = ScannerCubit();
    _line = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _scannerCubit.close();
    _line.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _scannerCubit,
      child: BlocListener<ScannerCubit, ScannerState>(
        listenWhen: (previous, current) =>
            !previous.completed && current.completed,
        listener: (context, state) {
          _scannerCubit.resetCompletion();
          Navigator.pushNamed(context, Routes.aiCompare);
        },
        child: BlocBuilder<ScannerCubit, ScannerState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  const Center(
                    child: Text(
                      'Camera Preview...',
                      style: TextStyle(color: Color(0xFF555555), fontSize: 18),
                    ),
                  ),
                  ScannerBody(
                    scanLine: _line,
                    verifying: state.verifying,
                    bottomContentInset: widget.bottomContentInset,
                    onSimulate: _scannerCubit.simulateScan,
                  ),
                  ScannerTopControls(
                    onBack: () => Navigator.pop(context),
                    onFlash: () {},
                  ),
                  if (state.verifying) const ScannerVerifyingOverlay(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
