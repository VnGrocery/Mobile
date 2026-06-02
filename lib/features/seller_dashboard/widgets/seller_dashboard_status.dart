import 'package:flutter/material.dart';

import '../../../data/data_hooks.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';

class SellerStatusCard extends StatelessWidget {
  final SellerDashboard dashboard;

  const SellerStatusCard({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final latest = dashboard.pledges.isEmpty ? null : dashboard.pledges.first;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tình trạng shop',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const SellerStatusRow(label: 'Trạng thái', value: 'active'),
          SellerStatusRow(
            label: 'Tổng ghi nhận',
            value: '${dashboard.pledges.length}',
          ),
          SellerStatusRow(
            label: 'Biên lai gần nhất',
            value: latest?.proofId ?? 'Chưa có',
          ),
          SellerStatusRow(
            label: 'Integrity',
            value: dashboard.warningCount > 0 ? 'Cần xem lại' : 'Ổn định',
          ),
        ],
      ),
    );
  }
}

class SellerStatusRow extends StatelessWidget {
  final String label;
  final String value;

  const SellerStatusRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
