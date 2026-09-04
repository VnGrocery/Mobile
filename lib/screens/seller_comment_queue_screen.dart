import 'package:flutter/material.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/core/ui/change_reason_dialog.dart';
import 'package:vngrocery/features/seller_shop/widgets/seller_empty_state.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// The seller's moderation queue.
///
/// Publishing and hiding both need a reason, because both are written into the
/// signed log: the shop's decision about a buyer's words is itself a record the
/// shop cannot edit later.
class SellerCommentQueueScreen extends StatefulWidget {
  final String shopId;

  const SellerCommentQueueScreen({super.key, required this.shopId});

  @override
  State<SellerCommentQueueScreen> createState() =>
      _SellerCommentQueueScreenState();
}

class _SellerCommentQueueScreenState extends State<SellerCommentQueueScreen> {
  ProductCommentThread _thread = const ProductCommentThread();
  bool _loading = true;
  bool _failed = false;
  // Replying only makes sense once a comment is public, so the queue - which
  // defaults to what still needs a decision - can switch to show those too.
  String _status = 'pending';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final remote = AppRepositories.instance.products.remote;
    if (remote == null) {
      // Not a quiet no-op: leaving _loading true here spins forever, which
      // reads as "still working" for something that will never finish.
      setState(() {
        _loading = false;
        _failed = true;
      });
      return;
    }
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final thread = await remote.shopComments(widget.shopId, status: _status);
      if (!mounted) return;
      setState(() {
        _thread = thread;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  void _setStatus(String status) {
    if (status == _status) return;
    setState(() => _status = status);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: Text(
          l10n.sellerCommentsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'pending',
                  label: Text(l10n.sellerCommentsStatusPending),
                ),
                ButtonSegment(
                  value: 'approved',
                  label: Text(l10n.sellerCommentsStatusApproved),
                ),
              ],
              selected: {_status},
              onSelectionChanged: (selection) => _setStatus(selection.first),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _body(l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(AppLocalizations l10n) {
    // Edge-to-edge is on from Android 15, so the last card's two decision
    // buttons would otherwise sit under the gesture bar.
    final bottom = 16 + MediaQuery.paddingOf(context).bottom;

    if (_failed || _thread.isEmpty) {
      // Kept scrollable on purpose: a RefreshIndicator over a short child
      // never fires, which is how "pull down to try again" became a lie.
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 40, 16, bottom),
        children: [
          if (_failed)
            SellerEmptyState(
              icon: Icons.cloud_off,
              title: l10n.commentsFailed,
              body: l10n.commentsFailedBody,
              actionLabel: l10n.homeRetryAction,
              onAction: _load,
            )
          else
            SellerEmptyState(
              icon: Icons.mark_email_read_outlined,
              title: l10n.sellerCommentsEmpty,
              body: l10n.sellerCommentsEmptyBody,
              actionLabel: l10n.sellerCommentsEmptyAction,
              onAction: () => Navigator.of(context).maybePop(),
            ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottom),
      itemCount: _thread.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) => _QueueCard(
        comment: _thread.items[index],
        onDecide: _decide,
        onReply: _reply,
      ),
    );
  }

  Future<void> _decide(ProductComment comment, bool approve) async {
    final l10n = AppLocalizations.of(context);
    final reason = await ChangeReasonDialog.show(
      context,
      title: approve ? l10n.sellerCommentsApprove : l10n.sellerCommentsReject,
      // The example has to match the decision: an approval prompted with
      // "posted on the wrong product" reads as a rejection.
      hint: approve
          ? l10n.sellerCommentsApproveHint
          : l10n.sellerCommentsReasonHint,
      label: l10n.sellerCommentsReasonLabel,
    );
    if (reason == null || !mounted) return;

    final remote = AppRepositories.instance.products.remote;
    if (remote == null) return;
    try {
      await remote.moderateProductComment(
        widget.shopId,
        comment.id,
        expectedVersion: comment.version,
        approve: approve,
        reason: reason,
      );
    } catch (_) {
      // A decision that never reached the server must not look saved.
      if (!mounted) return;
      AppFeedback.showSnackBar(
        context,
        l10n.sellerCommentsFailed,
        icon: Icons.error_outline,
      );
      return;
    }
    if (!mounted) return;
    AppFeedback.showSnackBar(context, l10n.sellerCommentsDone);
    await _load();
  }

  // Same one-slot rule the comment itself follows: a second reply replaces
  // the first rather than stacking a thread.
  Future<void> _reply(ProductComment comment, String body) async {
    final l10n = AppLocalizations.of(context);
    final remote = AppRepositories.instance.products.remote;
    if (remote == null) return;
    try {
      await remote.replyProductComment(
        widget.shopId,
        comment.id,
        expectedVersion: comment.version,
        body: body,
      );
    } catch (_) {
      if (!mounted) return;
      AppFeedback.showSnackBar(
        context,
        l10n.sellerCommentsReplyFailed,
        icon: Icons.error_outline,
      );
      return;
    }
    if (!mounted) return;
    AppFeedback.showSnackBar(context, l10n.sellerCommentsReplySent);
    await _load();
  }
}

class _QueueCard extends StatefulWidget {
  final ProductComment comment;
  final Future<void> Function(ProductComment comment, bool approve) onDecide;
  final Future<void> Function(ProductComment comment, String body) onReply;

  const _QueueCard({
    required this.comment,
    required this.onDecide,
    required this.onReply,
  });

  @override
  State<_QueueCard> createState() => _QueueCardState();
}

class _QueueCardState extends State<_QueueCard> {
  final _replyController = TextEditingController();
  bool _replying = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _submitReply() async {
    setState(() => _replying = true);
    await widget.onReply(widget.comment, _replyController.text.trim());
    if (!mounted) return;
    _replyController.clear();
    setState(() => _replying = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Which goods this is about. The queue crosses the whole shop, so
          // without it "posted on the wrong product" is unanswerable.
          if (widget.comment.productName.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 14,
                  color: palette.textSecondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.comment.productName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: palette.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Flexible(
                child: Text(
                  widget.comment.authorName.isEmpty
                      ? l10n.reviewAnonymousAuthor
                      : widget.comment.authorName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              if (widget.comment.isVerified) ...[
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
          const SizedBox(height: 8),
          Text(widget.comment.body),
          const SizedBox(height: 6),
          Text(
            formatDateTime(widget.comment.createdAt),
            style: TextStyle(fontSize: 11, color: palette.textTertiary),
          ),
          const SizedBox(height: 12),
          if (widget.comment.isApproved) ...[
            if (widget.comment.hasShopReply) ...[
              Container(
                decoration: BoxDecoration(
                  color: palette.elevatedCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.commentsShopReplyLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: palette.greenInk,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(widget.comment.shopReplyBody),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            TextField(
              controller: _replyController,
              maxLines: 3,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: l10n.sellerCommentsReplyHint,
                filled: true,
                fillColor: palette.field,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            FilledButton(
              onPressed: _replying ? null : _submitReply,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: _replying
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.sellerCommentsReply),
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        widget.onDecide(widget.comment, false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      foregroundColor: palette.warnInk,
                    ),
                    child: Text(l10n.sellerCommentsReject),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => widget.onDecide(widget.comment, true),
                    // No backgroundColor override: the theme's
                    // primaryGreenInk clears 4.5:1 under white text, the
                    // paint green does not.
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: Text(l10n.sellerCommentsApprove),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// One destination in the list under the shop form.
class SellerShopLinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SellerShopLinkRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: palette.positiveBg,
        child: Icon(icon, color: palette.greenInk),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

/// Row on the shop screen that opens the queue.
class SellerCommentQueueLink extends StatelessWidget {
  final String shopId;

  const SellerCommentQueueLink({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    return SellerShopLinkRow(
      icon: Icons.rate_review_outlined,
      label: AppLocalizations.of(context).sellerCommentsTitle,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SellerCommentQueueScreen(shopId: shopId),
        ),
      ),
    );
  }
}
