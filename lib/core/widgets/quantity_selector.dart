import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrease = quantity > min;
    final canIncrease = quantity < max;
    final l10n = AppLocalizations.of(context);

    // A 36dp-tall pill with compact-density buttons put the actual tap
    // target under the 48dp Material minimum on the +/- most cart and
    // product rows use. Letting the buttons keep their default 48x48 tap
    // area grows the pill to match rather than shrinking the target to fit.
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: l10n.commonDecreaseQuantity,
            onPressed: canDecrease ? () => onChanged(quantity - 1) : null,
            icon: const Icon(Icons.remove, size: 18),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            tooltip: l10n.commonIncreaseQuantity,
            onPressed: canIncrease ? () => onChanged(quantity + 1) : null,
            icon: const Icon(Icons.add, size: 18),
          ),
        ],
      ),
    );
  }
}
