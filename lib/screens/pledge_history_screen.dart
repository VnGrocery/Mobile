import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';

class PledgeHistoryScreen extends StatelessWidget {
  final String productId;
  const PledgeHistoryScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final history = AppDataHooks.instance.getPledges(productId);
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(title: const Text('Lịch sử ghi nhận')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Dòng thời gian sản phẩm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (history.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 100),
              child: Center(
                child: Text('Chưa có lịch sử ghi nhận',
                    style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...history.map((e) => _TimelineItem(item: e)),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final PledgeHistoryItem item;
  const _TimelineItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final color =
        item.isVerified ? AppColors.freshGreen : AppColors.warningOrange;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFD3D3D3).withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Card(
              color: AppColors.card,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(item.time,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(item.isVerified ? 'Verified' : 'Warning',
                              style: TextStyle(
                                  color: color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(item.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(item.description,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.darkGray)),
                    if (item.hasProof) ...[
                      const Divider(height: 24, thickness: 0.5),
                      Row(
                        children: [
                          const Icon(Icons.history,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text('Biên lai gốc: ${item.proofId}',
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
