import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/ui/app_feedback.dart';
import '../features/seller_labels/seller_label_presenter.dart';
import '../features/seller_labels/widgets/qr_label_components.dart';
import '../theme/app_palette.dart';

class QrLabelScreen extends StatelessWidget {
  final String pledgeId;

  const QrLabelScreen({super.key, required this.pledgeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: const Text('Mã QR sản phẩm')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const QrLabelIntro(),
            QrLabelPreviewCard(pledgeId: pledgeId),
            const Spacer(),
            QrLabelActions(
              onDownload: () => _downloadLabel(context),
              onPrint: () => _printLabel(context),
              onBackHome: () => Navigator.popUntil(
                context,
                (route) => route.settings.name == 'main' || route.isFirst,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadLabel(BuildContext context) {
    Clipboard.setData(
      ClipboardData(text: SellerLabelPresenter.clipboardText(pledgeId)),
    );
    AppFeedback.showSnackBar(context, 'Đã sao chép nội dung tem QR');
  }

  void _printLabel(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('In tem QR'),
        content: const Text(
          'Tem QR đã được đưa vào hàng đợi in demo. Kiểm tra máy in tại quầy trước khi dán lên sản phẩm.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
