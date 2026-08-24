import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/engagement/controllers/engagement_cubit.dart';
import 'package:vngrocery/features/engagement/widgets/chain_anchor_badge.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Follow, with the follower count and where that count sits on chain.
///
/// The count is only drawn once it has been read: a zero shown while the
/// request is still out would say the shop has nobody, then correct itself.
class FollowShopButton extends StatelessWidget {
  const FollowShopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return BlocBuilder<EngagementCubit, EngagementState>(
      builder: (context, state) {
        final data = state.data;
        final busy = state.pending != null;
        final following = data?.following ?? false;

        return Row(
          children: [
            if (following)
              OutlinedButton.icon(
                onPressed: busy || data == null ? null : () => _toggle(context),
                icon: const Icon(Icons.check, size: 18),
                label: Text(l10n.engagementFollowing),
              )
            else
              FilledButton.icon(
                onPressed: busy || data == null ? null : () => _toggle(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.engagementFollow),
              ),
            const SizedBox(width: 12),
            if (data != null) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.engagementFollowers(data.follows),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ChainAnchorBadge(engagement: data),
                  ],
                ),
              ),
            ] else if (state.failed)
              Expanded(
                child: Text(
                  l10n.engagementFailed,
                  style: TextStyle(fontSize: 12, color: palette.warnInk),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _toggle(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      await context.read<EngagementCubit>().toggle('follow');
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
