import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';

class VoucherSummaryCard extends StatelessWidget {
  final int usableCount;
  final int total;

  const VoucherSummaryCard({
    super.key,
    required this.usableCount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.positiveBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(Icons.wallet, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$usableCount voucher có thể dùng',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Text(
                  'Tổng cộng $total voucher trong ví',
                  style: TextStyle(color: palette.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VoucherEmptyState extends StatelessWidget {
  const VoucherEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.local_offer_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'Chưa có voucher phù hợp',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Quét sản phẩm, nhập mã hoặc thêm thủ công để lưu voucher vào ví.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class VoucherWalletToolbar extends StatelessWidget {
  final bool showUsed;
  final ValueChanged<bool> onShowUsedChanged;

  const VoucherWalletToolbar({
    super.key,
    required this.showUsed,
    required this.onShowUsedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Voucher của bạn',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FilterChip(
          selected: showUsed,
          showCheckmark: false,
          label: const Text('Hiện đã dùng'),
          onSelected: onShowUsedChanged,
        ),
      ],
    );
  }
}
