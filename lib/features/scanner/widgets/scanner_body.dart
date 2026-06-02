import 'package:flutter/material.dart';

import 'scanner_frame.dart';
import 'scanner_status_pill.dart';

class ScannerBody extends StatelessWidget {
  final Animation<double> scanLine;
  final bool verifying;
  final double bottomContentInset;
  final VoidCallback onSimulate;

  const ScannerBody({
    super.key,
    required this.scanLine,
    required this.verifying,
    required this.bottomContentInset,
    required this.onSimulate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomContentInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quét sản phẩm',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đưa mã QR hoặc tem sản phẩm vào khung hình',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            ScannerFrame(scanLine: scanLine),
            const SizedBox(height: 40),
            ScannerStatusPill(verifying: verifying),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: verifying ? null : onSimulate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(220, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                verifying ? 'Đang kiểm tra...' : 'Giả lập quét sản phẩm',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
