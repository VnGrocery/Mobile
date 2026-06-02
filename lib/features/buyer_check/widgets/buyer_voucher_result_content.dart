import 'package:flutter/material.dart';

import '../../../data/models.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/format.dart';
import 'buyer_voucher_price_line.dart';

class VoucherCheckResultContent extends StatelessWidget {
  final VoucherCheckResult result;
  final Color color;
  final ValueChanged<Voucher> onSaveVoucher;
  final VoidCallback onOpenWallet;

  const VoucherCheckResultContent({
    super.key,
    required this.result,
    required this.color,
    required this.onSaveVoucher,
    required this.onOpenWallet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              result.valid ? Icons.check_circle : Icons.info,
              color: color,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                result.message,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        if (result.valid) ...[
          const SizedBox(height: 8),
          PriceLine(
            label: 'Giảm',
            value: '-${formatVnd(result.discountAmount)}',
            color: AppColors.primaryGreen,
          ),
          PriceLine(
            label: 'Còn lại',
            value: formatVnd(result.finalPrice),
            color: AppColors.priceRed,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onSaveVoucher(result.voucher!),
                  icon: const Icon(Icons.wallet),
                  label: const Text('Lưu vào ví'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onOpenWallet,
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Mở ví'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
