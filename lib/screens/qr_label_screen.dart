import 'dart:ui' show ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/seller_labels/controllers/qr_label_cubit.dart';
import 'package:vngrocery/features/seller_labels/controllers/qr_label_state.dart';
import 'package:vngrocery/features/seller_labels/widgets/qr_label_components.dart';
import 'package:vngrocery/features/seller_labels/seller_label_presenter.dart';
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

  /// Wraps the label card so it can be rasterised at print resolution.
  final _labelKey = GlobalKey();
  bool _exporting = false;

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
                  RepaintBoundary(
                    key: _labelKey,
                    child: QrLabelPreviewCard(
                      pledgeId: state.pledgeId,
                      bundleId: state.bundleId,
                    ),
                  ),
                  const Spacer(),
                  QrLabelActions(
                    exporting: _exporting,
                    onExport: state.canPrint ? () => _exportLabel(state) : null,
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

  /// Rasterises the label and hands it to the system share sheet.
  Future<void> _exportLabel(QrLabelState state) async {
    // Read from State.context, which is what the mounted check below guards.
    final l10n = AppLocalizations.of(context);
    setState(() => _exporting = true);
    try {
      final boundary =
          _labelKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) throw StateError('label is not on screen');

      // 4x the logical size. A label printed at 1x is roughly 200 device
      // pixels of QR, which a phone camera struggles to resolve off paper.
      final image = await boundary.toImage(pixelRatio: 4);
      final data = await image.toByteData(format: ImageByteFormat.png);
      if (data == null) throw StateError('label did not encode');

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              data.buffer.asUint8List(),
              mimeType: 'image/png',
              // Named after the lot so a seller printing a morning's worth of
              // labels can tell the files apart.
              name: 'vngrocery-${state.bundleId}.png',
            ),
          ],
          fileNameOverrides: ['vngrocery-${state.bundleId}.png'],
        ),
      );
    } catch (_) {
      if (!mounted) return;
      AppFeedback.showSnackBar(
        context,
        l10n.qrLabelExportFailed,
        icon: Icons.error_outline,
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  void _copyLabel(BuildContext context, QrLabelState state) {
    final text = SellerLabelPresenter.clipboardText(
      AppLocalizations.of(context),
      pledgeId: state.pledgeId,
      bundleId: state.bundleId,
      bundleToken: state.bundleToken,
    );
    Clipboard.setData(ClipboardData(text: text));
    AppFeedback.showSnackBar(
      context,
      AppLocalizations.of(context).qrLabelCopied,
    );
  }
}
