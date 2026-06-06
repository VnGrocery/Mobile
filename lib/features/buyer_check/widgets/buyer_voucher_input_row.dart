import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';

class VoucherCheckInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCheck;

  const VoucherCheckInputRow({
    super.key,
    required this.controller,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: l10n.manualVoucherCodeLabel,
              hintText: l10n.buyerCheckVoucherCodeHint,
              prefixIcon: const Icon(Icons.confirmation_number),
            ),
            onSubmitted: (_) => onCheck(),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: onCheck,
            child: Text(l10n.cartCheckVoucher),
          ),
        ),
      ],
    );
  }
}
