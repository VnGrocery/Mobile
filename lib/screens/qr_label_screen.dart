import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/seller_labels/controllers/qr_label_cubit.dart';
import 'package:vngrocery/features/seller_labels/controllers/qr_label_state.dart';
import 'package:vngrocery/features/seller_labels/widgets/qr_label_components.dart';
import 'package:vngrocery/theme/app_palette.dart';

class QrLabelScreen extends StatefulWidget {
  final String pledgeId;

  const QrLabelScreen({super.key, required this.pledgeId});

  @override
  State<QrLabelScreen> createState() => _QrLabelScreenState();
}

class _QrLabelScreenState extends State<QrLabelScreen> {
  late final QrLabelCubit _labelCubit;

  @override
  void initState() {
    super.initState();
    _labelCubit = QrLabelCubit(pledgeId: widget.pledgeId);
  }

  @override
  void dispose() {
    _labelCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _labelCubit,
      child: BlocBuilder<QrLabelCubit, QrLabelState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(title: const Text('Mã QR sản phẩm')),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const QrLabelIntro(),
                  QrLabelPreviewCard(pledgeId: state.pledgeId),
                  const Spacer(),
                  QrLabelActions(
                    onDownload: () => _downloadLabel(context, state),
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
        },
      ),
    );
  }

  void _downloadLabel(BuildContext context, QrLabelState state) {
    Clipboard.setData(ClipboardData(text: state.clipboardText));
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
