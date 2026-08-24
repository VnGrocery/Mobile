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
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        if (index == state.events.length) return _footer(l10n, state);
        final event = state.events[index];
        return _ActivityCard(
          event: event,
          verification: state.checked[event.eventId],
          busy: state.verifying == event.eventId,
          onVerify: () => _verify(event.eventId),
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
            formatDateTime(event.createdAt),
            style: TextStyle(fontSize: 12, color: palette.textSecondary),
          ),
          if (event.sequence > 0) ...[
            const SizedBox(height: 2),
            Text(
              l10n.activitySequence(event.sequence),
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
          ],
          const SizedBox(height: 10),
          if (!event.signed)
            Text(
              l10n.activityUnsigned,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            )
          else
            _proof(context, l10n, palette),
        ],
      ),
    );
  }

  Widget _proof(
    BuildContext context,
    AppLocalizations l10n,
    AppPalette palette,
  ) {
    final result = verification;
    final hash = event.contentSha256;

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: hash));
            AppFeedback.showSnackBar(context, hash);
          },
          child: Text(
            // Enough of the hash to compare against the admin log by eye.
            '${hash.substring(0, hash.length < 12 ? hash.length : 12)}…',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: palette.textSecondary,
            ),
          ),
        ),
        if (busy)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else if (result == null)
          OutlinedButton(
            onPressed: onVerify,
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            child: Text(l10n.activityVerifyAction),
          )
        else
          _verdict(l10n, palette, result.verified),
      ],
    );
  }

  Widget _verdict(AppLocalizations l10n, AppPalette palette, bool ok) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ok ? palette.positiveBg : palette.warningBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ok ? Icons.verified : Icons.report_problem,
            size: 14,
            // Ink colours: the badge sits on a tinted background where the
            // brand green and #FF9800 both fall under 3:1.
            color: ok ? palette.greenInk : palette.warnInk,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              ok ? l10n.activityVerifiedOk : l10n.activityVerifiedBroken,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: ok ? palette.greenInk : palette.warnInk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
