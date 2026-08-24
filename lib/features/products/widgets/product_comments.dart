import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/core/widgets/collapsible_list.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/features/products/controllers/product_comments_cubit.dart';
import 'package:vngrocery/core/ui/change_reason_dialog.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// What buyers said about this product, and what the shop is not showing.
///
/// Only someone who checked the product at the stall can write here, so the
/// section is evidence rather than chatter. When the shop screens comments the
/// banner says so and names the number being held back: a filtered stall must
/// not be able to look like a quiet one.
class ProductComments extends StatefulWidget {
  const ProductComments({super.key});

  @override
  State<ProductComments> createState() => _ProductCommentsState();
}

class _ProductCommentsState extends State<ProductComments> {
  final TextEditingController _body = TextEditingController();

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return BlocBuilder<ProductCommentsCubit, ProductCommentsState>(
      builder: (context, state) {
        final thread = state.thread;
        return Container(
          decoration: BoxDecoration(
            color: palette.card,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.forum_outlined, size: 18, color: palette.greenInk),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.commentsTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (thread.moderation) ...[
                const SizedBox(height: 10),
                _ModerationBanner(thread: thread),
              ],
              const SizedBox(height: 12),
              if (state.loading && thread.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (state.failed)
                // There is no pull-to-refresh on the product screen, so the
                // recovery has to be a button the reader can actually press.
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.commentsFailed,
                      style: TextStyle(fontSize: 13, color: palette.warnInk),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () =>
                            context.read<ProductCommentsCubit>().load(),
                        child: Text(l10n.homeRetryAction),
                      ),
                    ),
                  ],
                )
              else if (thread.isEmpty)
                Text(
                  l10n.commentsEmpty,
                  style: TextStyle(fontSize: 13, color: palette.textSecondary),
                )
              else
                // Five, then a toggle - the same cut the change log and the
                // pledge timeline use, so a busy product does not push the
                // write box a screen and a half down.
                CollapsibleList(
                  itemCount: thread.items.length,
                  itemBuilder: (context, index, isLast) => Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                    child: _CommentTile(
                      comment: thread.items[index],
                      onWithdraw: _withdraw,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              _WriteBox(
                controller: _body,
                thread: thread,
                submitting: state.submitting,
                onSubmit: _submit,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    // State.context, not the builder's: the snack bars below run after an
    // await, and the analyzer can only prove a `mounted` check covers the
    // former.
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<ProductCommentsCubit>();
    try {
      await cubit.submit(_body.text.trim());
    } catch (_) {
      // A comment that never reached the server must not look posted.
      if (!mounted) return;
      AppFeedback.showSnackBar(
        context,
        l10n.commentsSendFailed,
        icon: Icons.error_outline,
      );
      return;
    }
    if (!mounted) return;
    _body.clear();
    setState(() {});
    AppFeedback.showSnackBar(context, l10n.commentsSent);
  }

  /// Taking back your own words. The shop can refuse a comment but never
  /// remove one, so this is the only hand that can, and it still has to say
  /// why: the withdrawal is signed like every other decision.
  Future<void> _withdraw(ProductComment comment) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<ProductCommentsCubit>();
    final reason = await ChangeReasonDialog.show(
      context,
      title: l10n.commentsWithdraw,
      hint: l10n.commentsWithdrawReason,
    );
    if (reason == null || !mounted) return;
    try {
      await cubit.withdraw(comment, reason);
    } catch (_) {
      if (!mounted) return;
      AppFeedback.showSnackBar(
        context,
        l10n.commentsSendFailed,
        icon: Icons.error_outline,
      );
      return;
    }
    if (!mounted) return;
    AppFeedback.showSnackBar(context, l10n.commentsWithdrawn);
  }
}

class _ModerationBanner extends StatelessWidget {
  final ProductCommentThread thread;

  const _ModerationBanner({required this.thread});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.warningBg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.filter_alt_outlined, size: 18, color: palette.warnInk),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.commentsModerationOn,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: palette.warnInk,
                  ),
                ),
                if (thread.withheldCount > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    l10n.commentsWithheld(thread.withheldCount),
                    style: TextStyle(fontSize: 12, color: palette.warnInk),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  l10n.commentsModerationEffect,
                  style: TextStyle(fontSize: 11, color: palette.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final ProductComment comment;
  final Future<void> Function(ProductComment comment) onWithdraw;

  const _CommentTile({required this.comment, required this.onWithdraw});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final mine = comment.authorUserId == SessionManager.instance.current.userId;

    return Container(
      decoration: BoxDecoration(
        // Not mutedSurface: on the light theme it is the same grey as the
        // section around it, so three comments read as one block of text.
        color: palette.elevatedCard,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  comment.authorName.isEmpty
                      ? l10n.reviewAnonymousAuthor
                      : comment.authorName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (comment.isVerified) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 14,
                        color: palette.greenInk,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          l10n.commentsVerifiedBadge,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: palette.greenInk,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(comment.body, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 6),
          Text(
            formatDateTime(comment.createdAt),
            style: TextStyle(fontSize: 11, color: palette.textTertiary),
          ),
          // Only the author is shown the state of their own unpublished
          // comment; to everyone else it is simply not in the list.
          if (mine && comment.isPending) ...[
            const SizedBox(height: 6),
            Text(
              l10n.commentsPendingMine,
              style: TextStyle(fontSize: 12, color: palette.warnInk),
            ),
          ],
          if (mine && comment.isRejected) ...[
            const SizedBox(height: 6),
            Text(
              l10n.commentsRejectedMine,
              style: TextStyle(fontSize: 12, color: palette.warnInk),
            ),
            if (comment.moderationReason.isNotEmpty)
              Text(
                comment.moderationReason,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: palette.textSecondary,
                ),
              ),
          ],
          if (mine)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => onWithdraw(comment),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(48, 48),
                  foregroundColor: palette.textSecondary,
                ),
                icon: const Icon(Icons.delete_outline, size: 16),
                label: Text(
                  l10n.commentsWithdraw,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WriteBox extends StatefulWidget {
  final TextEditingController controller;
  final ProductCommentThread thread;
  final bool submitting;
  final VoidCallback onSubmit;

  const _WriteBox({
    required this.controller,
    required this.thread,
    required this.submitting,
    required this.onSubmit,
  });

  @override
  State<_WriteBox> createState() => _WriteBoxState();
}

class _WriteBoxState extends State<_WriteBox> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    // Without a check on this product there is nothing behind the words, so
    // the box is replaced by what to do about it rather than by a dead button.
    if (!widget.thread.canComment) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Not iconMuted: that blue-grey measures 2.45:1 on the card, and
          // this icon sits beside the one sentence that gates the feature.
          Icon(Icons.qr_code_scanner, size: 16, color: palette.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.commentsNeedCheck,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
          ),
        ],
      );
    }

    final ready = widget.controller.text.trim().length >= 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          maxLines: 3,
          maxLength: 1000,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: l10n.commentsWriteHint,
            filled: true,
            fillColor: palette.field,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: ready && !widget.submitting ? widget.onSubmit : null,
          // No backgroundColor: the theme already uses primaryGreenInk, and
          // white on the paint green measures 3.04:1.
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          // The label stays put while sending, so the button keeps its width
          // and a screen reader keeps reading the same thing.
          icon: widget.submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.send, size: 18),
          label: Text(l10n.commentsSend),
        ),
        if (!ready && widget.controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              l10n.commentsTooShort,
              style: TextStyle(fontSize: 12, color: palette.warnInk),
            ),
          ),
      ],
    );
  }
}
