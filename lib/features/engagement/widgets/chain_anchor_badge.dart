import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Says whether the figures beside it are the ones written to a block.
///
/// A tap that has not been mined yet reads as waiting rather than as proven:
/// claiming an anchor the chain has not confirmed would make the badge worth
/// less than no badge at all.
class ChainAnchorBadge extends StatelessWidget {
  final Engagement engagement;

  const ChainAnchorBadge({super.key, required this.engagement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final anchored = engagement.anchored;

    // Nobody has marked this yet, so there is no figure owed to a block. A
    // badge here would promise a write that nothing has asked for.
    if (engagement.anchorStatus.isEmpty) {
      return const SizedBox.shrink();
    }

    return Tooltip(
      message: anchored && engagement.chainTxHash.isNotEmpty
          ? engagement.chainTxHash
          : l10n.engagementAnchorPending,
      // The pending -> anchored flip lands on whatever poll tick happens to
      // catch it, so it used to just pop between the two backgrounds. A
      // crossfade doesn't make the anchor land any sooner, but it stops the
      // change from reading as a glitch when it does.
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Container(
          key: ValueKey(anchored),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: anchored ? palette.positiveBg : palette.warningBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                anchored ? Icons.link : Icons.hourglass_bottom,
                size: 13,
                // Ink colours: the badge sits on a tinted background where the
                // brand green and #FF9800 both fall under 3:1.
                color: anchored ? palette.greenInk : palette.warnInk,
              ),
              const SizedBox(width: 4),
              Text(
                anchored ? l10n.engagementAnchored : l10n.engagementAnchorPending,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: anchored ? palette.greenInk : palette.warnInk,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
