import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';

class ScannerStatusPill extends StatelessWidget {
  final bool verifying;

  const ScannerStatusPill({super.key, required this.verifying});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      key: ValueKey(
        verifying ? 'scanner.status.verifying' : 'scanner.status.ready',
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verifying ? Icons.gps_fixed : Icons.location_on,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            verifying
                ? l10n.scannerStatusVerifying
                : l10n.scannerStatusReady,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
