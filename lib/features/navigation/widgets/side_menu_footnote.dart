import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

class SideMenuFootnote extends StatelessWidget {
  const SideMenuFootnote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.sideMenuFootnote,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.82),
                fontSize: 12,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
