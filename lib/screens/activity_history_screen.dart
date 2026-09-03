import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/activity/activity_copy.dart';
import 'package:vngrocery/features/activity/controllers/activity_cubit.dart';
import 'package:vngrocery/features/seller_shop/widgets/seller_empty_state.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// Everything this reader has done, in the order the log recorded it.
///
/// Each row can be re-checked against its own hash and signature, which is the
/// point of keeping the trail at all: a history nobody can audit is only a
/// list. Verifying is on demand rather than on load, because checking every
/// row on open would spend a request per row to answer a question the reader
/// has not asked.
class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  late final ActivityCubit _cubit;
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = ActivityCubit()..load();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 240) {
      _cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        key: const ValueKey('activity_history'),
        backgroundColor: context.palette.appBackground,
        appBar: AppBar(
          title: Text(
            l10n.activityTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: RefreshIndicator(
          color: AppColors.primaryGreen,
          onRefresh: _cubit.load,
          child: BlocBuilder<ActivityCubit, ActivityState>(
            builder: (context, state) {
              if (state.loading && state.events.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return _body(l10n, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _body(AppLocalizations l10n, ActivityState state) {
    final bottom = 16 + MediaQuery.paddingOf(context).bottom;

    if (state.events.isEmpty) {
      // Kept scrollable so pull-to-refresh still fires over a short child.
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 40, 16, bottom),
        children: [
          if (state.failed)
            SellerEmptyState(
              icon: Icons.cloud_off,
              title: l10n.activityFailed,
              body: l10n.commentsFailedBody,
              actionLabel: l10n.activityRetry,
              onAction: _cubit.load,
            )
          else
            SellerEmptyState(
              icon: Icons.history,
              title: l10n.activityEmptyTitle,
              body: l10n.activityEmptyBody,
              actionLabel: l10n.activityRetry,
              onAction: _cubit.load,
            ),
        ],
      );
    }

    return ListView.separated(
      controller: _scroll,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottom),
      itemCount: state.events.length + 1,
      // Spacing lives inside _TimelineRow instead of here, so the spine can
      // run through the gap between cards rather than breaking at each one.
      separatorBuilder: (_, _) => const SizedBox.shrink(),
      itemBuilder: (_, index) {
        if (index == state.events.length) return _footer(l10n, state);
        final event = state.events[index];
        final busy = state.verifyingIds.contains(event.eventId);
        return _TimelineRow(
          isFirst: index == 0,
          isLast: index == state.events.length - 1 && !state.hasMore,
          verification: state.checked[event.eventId],
          busy: busy,
          signed: event.signed,
          child: _ActivityCard(
            event: event,
            verification: state.checked[event.eventId],
            busy: busy,
            onVerify: () => _verify(event.eventId),
          ),
        );
      },
    );
  }

  Widget _footer(AppLocalizations l10n, ActivityState state) {
    if (state.loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.failed) {
      // The rows already read stay above this; the reader is told the rest is
      // missing rather than being left to assume the trail simply ends here.
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: TextButton(
            onPressed: _cubit.loadMore,
            child: Text(l10n.activityFailed),
          ),
        ),
      );
    }
    return const SizedBox(height: 8);
  }

  /// Manual tap through the badge routes here so a failed check surfaces to
  /// the reader; auto-verify on load swallows the same failure silently
  /// since there's no tap for the reader to have made.
  Future<void> _verify(String eventId) async {
    final l10n = AppLocalizations.of(context);
    try {
      await _cubit.verify(eventId);
    } catch (_) {
      if (!mounted) return;
      AppFeedback.showSnackBar(
        context,
        l10n.activityVerifyFailed,
        icon: Icons.error_outline,
      );
    }
  }

}

/// The spine from History of Everything: a continuous line down the left
/// edge with one node per entry, so the trail reads as a single chain rather
/// than a stack of unrelated cards. Same idea, our own palette — the node
/// colour is the same read as the badge on the card beside it, so the state
/// is visible without opening anything.
class _TimelineRow extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool signed;
  final bool busy;
  final ActivityVerification? verification;
  final Widget child;

  const _TimelineRow({
    required this.isFirst,
    required this.isLast,
    required this.signed,
    required this.busy,
    required this.verification,
    required this.child,
  });

  Color _dotColor(AppPalette palette) {
    if (!signed || busy) return palette.textSecondary;
    if (verification == null) return palette.textSecondary;
    return verification!.verified ? palette.greenInk : palette.warnInk;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final line = palette.border;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Expanded(child: Container(width: 2, color: isFirst ? Colors.transparent : line)),
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: _dotColor(palette)),
                ),
                Expanded(child: Container(width: 2, color: isLast ? Colors.transparent : line)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [child, if (!isLast) const SizedBox(height: 12)],
            ),
          ),
        ],
      ),
    );
  }
}

/// One row, laid out like a GitHub commit: message on top, short hash and a
/// verified/unverified badge on the row below. The badge doubles as the
/// verify trigger — tapping it is what "Kiểm chứng" used to be a separate
/// button for — and the hash opens the full record the same way a SHA link
/// opens a commit page.
class _ActivityCard extends StatelessWidget {
  final ActivityEvent event;
  final ActivityVerification? verification;
  final bool busy;
  final VoidCallback onVerify;

  const _ActivityCard({
    required this.event,
    required this.verification,
    required this.busy,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ActivityCopy.label(l10n, event),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            event.sequence > 0
                ? '${formatDateTime(event.createdAt)} · ${l10n.activitySequence(event.sequence)}'
                : formatDateTime(event.createdAt),
            style: TextStyle(fontSize: 12, color: palette.textSecondary),
          ),
          const SizedBox(height: 10),
          if (!event.signed)
            Text(
              l10n.activityUnsigned,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            )
          else
            Row(
              children: [
                _ShaChip(hash: event.contentSha256, onTap: () => _openDetail(context)),
                const Spacer(),
                _VerifyBadge(
                  result: verification,
                  busy: busy,
                  onTap: verification == null ? onVerify : () => _openDetail(context),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.palette.appBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ActivityDetailSheet(
        event: event,
        verification: verification,
        busy: busy,
        onVerify: onVerify,
      ),
    );
  }
}

/// The first 6 characters of the content hash, in a chip like GitHub's SHA
/// link — enough to eyeball against a server log, not enough to be the proof
/// itself (that's what tapping through to the detail sheet is for).
class _ShaChip extends StatelessWidget {
  final String hash;
  final VoidCallback onTap;

  const _ShaChip({required this.hash, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final short = hash.substring(0, hash.length < 6 ? hash.length : 6);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: palette.mutedSurface,
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          short,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            color: palette.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Three states, one pill: not checked yet (muted, tap to run the check),
/// checked and intact (green), checked and broken (warning). Same shape in
/// all three so the row doesn't jump when the result comes back.
class _VerifyBadge extends StatelessWidget {
  final ActivityVerification? result;
  final bool busy;
  final VoidCallback onTap;

  const _VerifyBadge({
    required this.result,
    required this.busy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    if (busy) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final IconData icon;
    final Color bg;
    final Color ink;
    final String label;
    if (result == null) {
      icon = Icons.help_outline;
      bg = palette.mutedSurface;
      ink = palette.textSecondary;
      label = l10n.activityUnverifiedBadge;
    } else if (result!.verified) {
      icon = Icons.verified;
      bg = palette.positiveBg;
      ink = palette.greenInk;
      label = l10n.activityVerifiedBadge;
    } else {
      icon = Icons.report_problem;
      bg = palette.warningBg;
      ink = palette.warnInk;
      label = l10n.activityBrokenBadge;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: ink),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ink),
            ),
          ],
        ),
      ),
    );
  }
}

/// The commit-page equivalent: full hash, signature, parent link and (once
/// run) the per-check breakdown, each copyable on tap.
class _ActivityDetailSheet extends StatelessWidget {
  final ActivityEvent event;
  final ActivityVerification? verification;
  final bool busy;
  final VoidCallback onVerify;

  const _ActivityDetailSheet({
    required this.event,
    required this.verification,
    required this.busy,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final bottom = 16 + MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.activityDetailTitle,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              ActivityCopy.label(l10n, event),
              style: TextStyle(fontSize: 13, color: palette.textSecondary),
            ),
            const SizedBox(height: 16),
            _row(context, l10n.activityDetailHash, event.contentSha256),
            _row(context, l10n.activityDetailSignature, event.signature),
            if (event.previousEventId.isNotEmpty)
              _row(context, l10n.activityDetailPrevious, event.previousEventId),
            const SizedBox(height: 8),
            if (busy)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (verification == null)
              OutlinedButton(
                onPressed: onVerify,
                child: Text(l10n.activityVerifyAction),
              )
            else ...[
              _check(context, l10n.activityDetailContentMatch, verification!.contentHashValid),
              _check(context, l10n.activityDetailSignatureMatch, verification!.signatureValid),
              _check(context, l10n.activityDetailChainMatch, verification!.chainLinkValid),
              const SizedBox(height: 8),
              Text(
                verification!.verified ? l10n.activityVerifiedOk : l10n.activityVerifiedBroken,
                style: TextStyle(
                  fontSize: 12,
                  color: verification!.verified ? palette.greenInk : palette.warnInk,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: value));
          AppFeedback.showSnackBar(context, value);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: palette.textSecondary)),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _check(BuildContext context, String label, bool ok) {
    final palette = context.palette;
    final color = ok ? palette.greenInk : palette.warnInk;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle : Icons.cancel, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 13, color: color)),
        ],
      ),
    );
  }
}
