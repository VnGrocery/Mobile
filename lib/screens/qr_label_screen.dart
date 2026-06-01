import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class QrLabelScreen extends StatelessWidget {
  final String pledgeId;
  const QrLabelScreen({super.key, required this.pledgeId});

  void _notImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang được phát triển')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Mã QR sản phẩm')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Mã QR đã sẵn sàng!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.meatRed)),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 32),
              child: Text('Hãy in và dán mã này lên bao bì sản phẩm.',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
            AspectRatio(
              aspectRatio: 0.75,
              child: Card(
                color: AppColors.card,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('VNMeat Verification',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: AppColors.meatRed)),
                      const SizedBox(height: 24),
                      Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD3D3D3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const FittedBox(
                          child: Icon(Icons.qr_code_2, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('ID Cam kết: $pledgeId',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      const Text('Thịt bò thăn Úc - Seller Score: 8.5',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 16),
                      const Text('Quét mã để kiểm chứng độ tươi sống',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.meatRed,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () => _notImplemented(context),
                      icon: const Icon(Icons.download),
                      label: const Text('Tải về'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: () => _notImplemented(context),
                      icon: const Icon(Icons.print),
                      label: const Text('In tem'),
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => Navigator.popUntil(
                  context, (r) => r.settings.name == 'main' || r.isFirst),
              child: const Text('Về màn hình chính',
                  style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
