import 'package:flutter/material.dart';

/// Composition guide for photographing a product.
///
/// It used to be a square outline with a red line sweeping down it, which is
/// the visual language of a code reader - and this screen reads no codes. That
/// belongs to QrScanScreen, which has its own frame; here it told people to
/// hold still and wait for a scan that was never coming.
class ScannerFrame extends StatelessWidget {
  /// Corner length as a fraction of the frame, so the brackets stay in
  /// proportion if the size changes.
  static const _cornerFraction = 0.18;

  final double size;

  const ScannerFrame({super.key, this.size = 280});

  @override
  Widget build(BuildContext context) {
    final corner = size * _cornerFraction;
    const border = BorderSide(color: Colors.white, width: 3);
    return Semantics(
      label: 'scanner.scan_frame',
      child: SizedBox(
        key: const ValueKey('scanner.frame'),
        width: size,
        height: size,
        child: Stack(
          children: [
            for (final alignment in [
              Alignment.topLeft,
              Alignment.topRight,
              Alignment.bottomLeft,
              Alignment.bottomRight,
            ])
              Align(
                alignment: alignment,
                child: Container(
                  width: corner,
                  height: corner,
                  decoration: BoxDecoration(
                    border: Border(
                      top: alignment.y < 0 ? border : BorderSide.none,
                      bottom: alignment.y > 0 ? border : BorderSide.none,
                      left: alignment.x < 0 ? border : BorderSide.none,
                      right: alignment.x > 0 ? border : BorderSide.none,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
