import 'package:flutter/material.dart';

import '../features/scanner/widgets/scanner_components.dart';
import '../routes/app_routes.dart';

class ScannerScreen extends StatefulWidget {
  final double bottomContentInset;

  const ScannerScreen({super.key, this.bottomContentInset = 0});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _line;
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _line = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _line.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            verifying: _verifying,
            bottomContentInset: widget.bottomContentInset,
            onSimulate: _simulate,
          ),
          ScannerTopControls(
            onBack: () => Navigator.pop(context),
            onFlash: () {},
          ),
          if (_verifying) const ScannerVerifyingOverlay(),
        ],
      ),
    );
  }

  Future<void> _simulate() async {
    setState(() => _verifying = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _verifying = false);
    Navigator.pushNamed(context, Routes.aiCompare);
  }
}
