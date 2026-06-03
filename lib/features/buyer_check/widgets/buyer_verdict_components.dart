import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class BuyerVerdictCard extends StatelessWidget {
  final BuyerCheckResult result;

  const BuyerVerdictCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Card(
      color: palette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'So với dữ liệu gần nhất',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.warningOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Kết quả: ${result.verdict}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Kết quả dựa trên ảnh bạn gửi và thông tin đã ghi nhận.',
                style: TextStyle(fontSize: 14, color: palette.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
