import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';

class ChangePasswordSubmitButton extends StatelessWidget {
  final bool saving;
  final VoidCallback onPressed;

  const ChangePasswordSubmitButton({
    super.key,
    required this.saving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 54,
      child: FilledButton.icon(
        onPressed: saving ? null : onPressed,
        icon: saving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.lock_reset),
        label: Text(
          saving ? l10n.authPasswordUpdateSaving : l10n.authPasswordUpdateSubmit,
        ),
      ),
    );
  }
}
