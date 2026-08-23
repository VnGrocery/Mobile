import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';

class SellerShopSaveButton extends StatelessWidget {
  final bool saving;
  final bool enabled;

  /// There is no shop behind the form yet, so the button creates one rather
  /// than saving changes to something that does not exist.
  final bool creating;
  final VoidCallback onSave;

  const SellerShopSaveButton({
    super.key,
    required this.saving,
    required this.enabled,
    required this.onSave,
    this.creating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton.icon(
        onPressed: saving || !enabled ? null : onSave,
        icon: saving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(creating ? Icons.add_business : Icons.save),
        label: Text(
          saving
              ? AppLocalizations.of(context).authPasswordUpdateSaving
              : creating
              ? AppLocalizations.of(context).sellerDashboardNoShopAction
              : AppLocalizations.of(context).accountSaveProfileChanges,
        ),
      ),
    );
  }
}
