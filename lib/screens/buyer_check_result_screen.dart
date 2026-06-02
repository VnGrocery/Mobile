import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/session.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';

class BuyerCheckResultScreen extends StatelessWidget {
  const BuyerCheckResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = AppDataHooks.instance.getLastBuyerCheck();
    final fair = result.locationStatus == 'near';
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(title: const Text('Kết quả kiểm tra')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Score circle
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.elevatedCard,
                border: Border.all(color: AppColors.warningOrange, width: 8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${result.actualScore}',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: scheme.onSurface)),
                  const Text('Điểm đánh giá',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Fairness badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: fair ? palette.positiveBg : palette.warningBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(fair ? Icons.gps_fixed : Icons.gps_off,
                      size: 16,
                      color: fair
                          ? AppColors.trustGreen
                          : AppColors.warningOrange),
                  const SizedBox(width: 8),
                  Text(fair ? 'Ghi nhận tại quầy' : 'Cần thêm lượt xác nhận',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: fair
                              ? AppColors.trustGreen
                              : AppColors.warningOrange)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
              child: Text(
                fair
                    ? 'Bạn đang ở gần cửa hàng. Ghi nhận này được tính vào dữ liệu gần đây.'
                    : 'Bạn không ở gần cửa hàng. Ghi nhận này chỉ dùng để tham khảo.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),
            // Verdict card
            Card(
              color: palette.card,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('So với dữ liệu gần nhất',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                              color: AppColors.warningOrange,
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Kết quả: ${result.verdict}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Kết quả dựa trên ảnh bạn gửi và thông tin đã ghi nhận.',
                        style: TextStyle(
                          fontSize: 14,
                          color: palette.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () {
                  final shopId = SessionManager.instance.shopId ?? 's1';
                  Navigator.pushNamed(context, Routes.storeDetail,
                      arguments: shopId);
                },
                child: const Text('Xem cửa hàng',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Chụp lại', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
