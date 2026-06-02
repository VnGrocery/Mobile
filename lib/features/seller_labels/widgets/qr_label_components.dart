import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';

class QrLabelIntro extends StatelessWidget {
  const QrLabelIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Mã QR đã sẵn sàng!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.meatRed,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: 32),
          child: Text(
            'Hãy in và dán mã này lên bao bì sản phẩm.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class QrLabelPreviewCard extends StatelessWidget {
  final String pledgeId;

  const QrLabelPreviewCard({super.key, required this.pledgeId});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 0.75,
      child: Card(
        color: palette.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'VnGrocery Check',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: AppColors.meatRed,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: palette.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FittedBox(
                  child: Icon(Icons.qr_code_2, color: scheme.onSurface),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Mã ghi nhận: $pledgeId',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Text(
                'Thịt bò thăn Úc - Điểm đánh giá: 8.5',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Quét mã để kiểm tra thông tin sản phẩm',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.meatRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QrLabelActions extends StatelessWidget {
  final VoidCallback onDownload;
  final VoidCallback onPrint;
  final VoidCallback onBackHome;

  const QrLabelActions({
    super.key,
    required this.onDownload,
    required this.onPrint,
    required this.onBackHome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: onDownload,
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
                  onPressed: onPrint,
                  icon: const Icon(Icons.print),
                  label: const Text('In tem'),
                ),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onBackHome,
          child: const Text(
            'Về màn hình chính',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
