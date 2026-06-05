import 'package:flutter/material.dart';

class ScannerFrame extends StatelessWidget {
  final Animation<double> scanLine;

  const ScannerFrame({super.key, required this.scanLine});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'scanner.scan_frame',
      child: SizedBox(
        key: const ValueKey('scanner.frame'),
        width: 280,
        height: 280,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            AnimatedBuilder(
              animation: scanLine,
              builder: (_, __) => Positioned(
                top: scanLine.value * 278,
                left: 0,
                right: 0,
                child: Container(height: 2, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
