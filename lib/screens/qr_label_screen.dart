import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/seller_labels/controllers/qr_label_cubit.dart';
import 'package:vngrocery/features/seller_labels/controllers/qr_label_state.dart';
import 'package:vngrocery/features/seller_labels/widgets/qr_label_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
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
          final l10n = AppLocalizations.of(context);
          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(title: Text(l10n.qrLabelTitle)),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const QrLabelIntro(),
                  QrLabelPreviewCard(
                    pledgeId: state.pledgeId,
                    bundleToken: state.bundleToken,
                  ),
                  const Spacer(),
                  QrLabelActions(
                    onCopy: () => _copyLabel(context, state),
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

  void _copyLabel(BuildContext context, QrLabelState state) {
    Clipboard.setData(ClipboardData(text: state.clipboardText));
    AppFeedback.showSnackBar(
      context,
      AppLocalizations.of(context).qrLabelCopied,
    );
  }
}
