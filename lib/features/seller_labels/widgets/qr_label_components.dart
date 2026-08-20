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
            color: AppColors.meatRed,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: 32),
          child: Text(
            l10n.qrLabelReadyBody,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class QrLabelPreviewCard extends StatelessWidget {
  final String pledgeId;

  /// The bundleToken to encode. Empty means there is nothing to print yet.
  final String bundleToken;

  const QrLabelPreviewCard({
    super.key,
    required this.pledgeId,
    this.bundleToken = '',
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
                  color: AppColors.meatRed,
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
                child: bundleToken.isEmpty
                    ? FittedBox(
                        child: Icon(Icons.qr_code_2, color: scheme.onSurface),
                      )
                    : QrImageView(
                        data: bundleToken,
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                      ),
              ),
              const SizedBox(height: 24),
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
    final l10n = AppLocalizations.of(context);
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
                  label: Text(l10n.qrLabelDownload),
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
          child: Text(
            l10n.qrLabelBackHome,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
