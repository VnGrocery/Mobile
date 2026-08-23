import 'package:flutter/material.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final remote = AppRepositories.instance.products.remote;
    if (remote == null) return;
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final thread = await remote.shopComments(
        widget.shopId,
        status: 'pending',
      );
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
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_failed)
                    Text(
                      l10n.commentsFailed,
                      style: TextStyle(color: context.palette.warnInk),
                    )
                  else if (_thread.isEmpty)
                    Text(
                      l10n.sellerCommentsEmpty,
                      style: TextStyle(color: context.palette.textSecondary),
                    )
                  else
                    for (final comment in _thread.items) ...[
                      _QueueCard(comment: comment, onDecide: _decide),
                      const SizedBox(height: 12),
                    ],
                ],
              ),
      ),
    );
  }

  Future<void> _decide(ProductComment comment, bool approve) async {
    final l10n = AppLocalizations.of(context);
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _ReasonDialog(approve: approve),
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
}

class _QueueCard extends StatelessWidget {
  final ProductComment comment;
  final Future<void> Function(ProductComment comment, bool approve) onDecide;

  const _QueueCard({required this.comment, required this.onDecide});

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
          Row(
            children: [
              Flexible(
                child: Text(
                  comment.authorName.isEmpty
                      ? l10n.reviewAnonymousAuthor
                      : comment.authorName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
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
          const SizedBox(height: 8),
          Text(comment.body),
          const SizedBox(height: 6),
          Text(
            formatDateTime(comment.createdAt),
            style: TextStyle(fontSize: 11, color: palette.textTertiary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onDecide(comment, false),
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
                  onPressed: () => onDecide(comment, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
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

class _ReasonDialog extends StatefulWidget {
  final bool approve;

  const _ReasonDialog({required this.approve});

  @override
  State<_ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<_ReasonDialog> {
  final TextEditingController _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ready = _reason.text.trim().length >= 5;
    return AlertDialog(
      title: Text(
        widget.approve ? l10n.sellerCommentsApprove : l10n.sellerCommentsReject,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _reason,
            autofocus: true,
            maxLength: 200,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: l10n.sellerCommentsReasonLabel,
              // The example has to match the decision: an approval prompted
              // with "posted on the wrong product" reads as a rejection.
              hintText: widget.approve
                  ? l10n.sellerCommentsApproveHint
                  : l10n.sellerCommentsReasonHint,
              counterText: '',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.changeReasonExplainer,
            style: TextStyle(
              fontSize: 12,
              color: context.palette.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: ready
              ? () => Navigator.of(context).pop(_reason.text.trim())
              : null,
          child: Text(l10n.commonConfirm),
        ),
      ],
    );
  }
}

/// Row on the shop screen that opens the queue.
class SellerCommentQueueLink extends StatelessWidget {
  final String shopId;

  const SellerCommentQueueLink({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: palette.positiveBg,
        child: Icon(Icons.rate_review_outlined, color: palette.greenInk),
      ),
      title: Text(
        l10n.sellerCommentsTitle,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SellerCommentQueueScreen(shopId: shopId),
        ),
      ),
    );
  }
}
