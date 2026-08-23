import 'package:flutter/material.dart';

import 'scanner_circle_button.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

class ScannerTopControls extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onFlash;

  const ScannerTopControls({
    super.key,
    required this.onBack,
    required this.onFlash,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ScannerCircleButton(
              icon: Icons.arrow_back,
              onTap: onBack,
              label: l10n.a11yBack,
            ),
            ScannerCircleButton(
              icon: Icons.flash_on,
              onTap: onFlash,
              label: l10n.a11yToggleFlash,
            ),
          ],
        ),
      ),
    );
  }
}
