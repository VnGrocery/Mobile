import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class QrLabelIntro extends StatelessWidget {
  const QrLabelIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Text(
          l10n.qrLabelReadyTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: 32),
          child: Text(
            l10n.qrLabelReadyBody,
            style: TextStyle(fontSize: 14, color: context.palette.textSecondary),
          ),
        ),
      ],
    );
  }
}

class QrLabelPreviewCard extends StatelessWidget {
  final String pledgeId;

  /// The lot code to encode. Empty means there is nothing to print yet.
  ///
  /// This used to be the bundleToken, which was the wrong thing to print: the
  /// token expires in thirty minutes and is consumed by the first successful
  /// check, so a label stuck on a crate was dead before the crate reached the
  /// stall and only ever worked for one buyer. The lot code does not expire
  /// and every buyer can scan it.
  final String bundleId;

  const QrLabelPreviewCard({
    super.key,
    required this.pledgeId,
    this.bundleId = '',
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: palette.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                // A real code, not a placeholder icon: this is what the buyer
                // scans to verify the bundle.
                child: bundleId.isEmpty
                    ? FittedBox(
                        child: Icon(Icons.qr_code_2, color: scheme.onSurface),
                      )
                    : QrImageView(
                        data: bundleId,
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                        // High, not medium: this one gets printed and then
                        // lives on a crate, where it picks up scuffs and damp
                        // that an on-screen code never sees. A lot code is
                        // short enough that the extra redundancy costs
                        // nothing in module count.
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      ),
              ),
              const SizedBox(height: 16),
              // Printed under the QR so a scuffed label is still usable: the
              // code can be read out or typed in by hand.
              if (bundleId.isNotEmpty)
                SelectableText(
                  bundleId,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                l10n.qrLabelRecordId(pledgeId),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.qrLabelScanHint,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.primaryGreen,
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
  final VoidCallback onCopy;
  final VoidCallback onBackHome;

  /// Exports the label as an image. Null while there is no code to print.
  final VoidCallback? onExport;

  final bool exporting;

  const QrLabelActions({
    super.key,
    required this.onCopy,
    required this.onBackHome,
    this.onExport,
    this.exporting = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        // There used to be an "In tem" button that opened a dialog claiming
        // the label had been queued to a printer, while nothing was printed.
        // This hands the rendered label to the system share sheet, which is a
        // thing that actually happens: save it, or send it to a printer app.
        SizedBox(
          height: 56,
          width: double.infinity,
          child: FilledButton.icon(
            key: const ValueKey('qr_label.export_button'),
            onPressed: exporting ? null : onExport,
            icon: const Icon(Icons.ios_share),
            label: Text(
              exporting ? l10n.qrLabelExporting : l10n.qrLabelExportAction,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onCopy,
            icon: const Icon(Icons.copy),
            label: Text(l10n.qrLabelCopyAction),
          ),
        ),
        TextButton(
          onPressed: onBackHome,
          child: Text(
            l10n.qrLabelBackHome,
            style: TextStyle(color: context.palette.textSecondary),
          ),
        ),
      ],
    );
  }
}
