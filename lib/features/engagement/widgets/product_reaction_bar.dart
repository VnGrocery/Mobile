import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/engagement/controllers/engagement_cubit.dart';
import 'package:vngrocery/features/engagement/widgets/chain_anchor_badge.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Like and love for one product, with the totals and their anchor.
class ProductReactionBar extends StatelessWidget {
  const ProductReactionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<EngagementCubit, EngagementState>(
      builder: (context, state) {
        final data = state.data;
        if (data == null) {
          // Nothing to say yet. An empty row is better than two buttons that
          // would report zero and then jump.
          return state.failed
              ? Text(
                  l10n.engagementFailed,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.palette.warnInk,
                  ),
                )
              : const SizedBox.shrink();
        }

        return Wrap(
          spacing: 10,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _ReactionChip(
              icon: data.liked ? Icons.thumb_up : Icons.thumb_up_outlined,
              label: l10n.engagementLikes(data.likes),
              on: data.liked,
              busy: state.pending == 'like',
              onTap: () => _toggle(context, 'like'),
            ),
            _ReactionChip(
              icon: data.loved ? Icons.favorite : Icons.favorite_border,
              label: l10n.engagementLoves(data.loves),
              on: data.loved,
              busy: state.pending == 'love',
              onTap: () => _toggle(context, 'love'),
            ),
            ChainAnchorBadge(engagement: data),
          ],
        );
      },
    );
  }

  Future<void> _toggle(BuildContext context, String kind) async {
    final l10n = AppLocalizations.of(context);
    try {
      await context.read<EngagementCubit>().toggle(kind);
    } catch (_) {
      if (!context.mounted) return;
      AppFeedback.showSnackBar(
        context,
        l10n.engagementActionFailed,
        icon: Icons.error_outline,
      );
    }
  }
}

class _ReactionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool on;
  final bool busy;
  final VoidCallback onTap;

  const _ReactionChip({
    required this.icon,
    required this.label,
    required this.on,
    required this.busy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    // The chip carries text, so the marked state uses the ink green rather
    // than the paint green.
    final colour = on ? palette.greenInk : palette.textSecondary;

    return InkWell(
      onTap: busy ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: on ? palette.positiveBg : palette.mutedSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colour),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colour,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
