import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

/// Turns the log's action codes into Vietnamese.
///
/// The log speaks in `engagement.added` and `buyer_check.completed`, which is
/// server vocabulary. An unrecognised code falls back to the code itself
/// rather than to a blank row: a history that silently drops entries it does
/// not recognise is not a history.
class ActivityCopy {
  const ActivityCopy._();

  static String label(AppLocalizations l10n, ActivityEvent event) {
    final action = event.action.trim();
    // Only the status separates a like from a love; the action is the same.
    final added = action == 'engagement.added';
    return switch ((action, event.status.trim())) {
      ('engagement.added' || 'engagement.removed', 'follow') =>
        added ? l10n.activityFollowAdded : l10n.activityFollowRemoved,
      ('engagement.added' || 'engagement.removed', 'like') =>
        added ? l10n.activityLikeAdded : l10n.activityLikeRemoved,
      ('engagement.added' || 'engagement.removed', 'love') =>
        added ? l10n.activityLoveAdded : l10n.activityLoveRemoved,
      ('buyer_check.completed', _) => l10n.activityCheckCompleted,
      ('product_comment.created', _) => l10n.activityCommentCreated,
      ('product_comment.updated', _) => l10n.activityCommentUpdated,
      ('product_comment.deleted', _) => l10n.activityCommentDeleted,
      ('shop_review.created', _) => l10n.activityReviewCreated,
      ('shop_review.updated', _) => l10n.activityReviewUpdated,
      ('shop_review.deleted', _) => l10n.activityReviewDeleted,
      ('pledge.committed', _) => l10n.activityPledgeCommitted,
      ('pledge.revoked', _) => l10n.activityPledgeRevoked,
      ('pledge.reanchored', _) => l10n.activityPledgeReanchored,
      ('shop.updated', _) => l10n.activityShopUpdated,
      ('account.created', _) => l10n.activityAccountCreated,
      _ => action,
    };
  }
}
