import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

typedef CollapsibleItemBuilder =
    Widget Function(BuildContext context, int index, bool isLast);

/// A list that shows its most recent few entries and hides the rest behind an
/// arrow.
///
/// The product change log and the pledge timeline both print every entry a
/// product has ever had, which on a well recorded product is a screen or two of
/// scrolling before anything else on the page can be reached.
class CollapsibleList extends StatefulWidget {
  final int itemCount;
  final CollapsibleItemBuilder itemBuilder;

  /// How many entries are shown before the reader asks for more.
  final int collapsedCount;

  const CollapsibleList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.collapsedCount = 5,
  });

  @override
  State<CollapsibleList> createState() => _CollapsibleListState();
}

class _CollapsibleListState extends State<CollapsibleList> {
  bool _expanded = false;

  @override
  void didUpdateWidget(CollapsibleList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A shorter list can no longer be expanded; leaving the flag set would
    // hide the toggle in the wrong state when it grows again.
    if (widget.itemCount <= widget.collapsedCount) _expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hidden = widget.itemCount - widget.collapsedCount;
    final shown = _expanded || hidden <= 0
        ? widget.itemCount
        : widget.collapsedCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < shown; i++)
                widget.itemBuilder(context, i, i == shown - 1),
            ],
          ),
        ),
        if (hidden > 0)
          Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: Icon(
                _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 20,
              ),
              label: Text(
                _expanded ? l10n.historyShowLess : l10n.historyShowMore(hidden),
              ),
              // Ink, not paint: the label is text, and the brand green
              // measures 3.44:1 on white.
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryGreenInk,
              ),
            ),
          ),
      ],
    );
  }
}
