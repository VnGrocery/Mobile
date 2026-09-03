import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

/// How one proof status should look. Presentation lives next to the status so
/// every screen renders a verdict the same way.
class _BadgeStyle {
  final Color foreground;
  final Color background;
  final IconData icon;

  const _BadgeStyle(this.foreground, this.background, this.icon);
}

const _styles = <ProofStatus, _BadgeStyle>{
  ProofStatus.verified: _BadgeStyle(
    AppColors.trustGreen,
    AppColors.trustGreenBg,
    Icons.verified,
  ),
  ProofStatus.pending: _BadgeStyle(
    AppColors.gray,
    AppColors.lightGray,
    Icons.hourglass_top,
  ),
  ProofStatus.warning: _BadgeStyle(
    AppColors.warningOrange,
    AppColors.warningBg,
    Icons.error_outline,
  ),
  ProofStatus.revoked: _BadgeStyle(
    AppColors.priceRed,
    AppColors.errorBg,
    Icons.gpp_bad,
  ),
  ProofStatus.unknown: _BadgeStyle(
    AppColors.gray,
    AppColors.lightGray,
    Icons.help_outline,
  ),
};

/// Localised label and explanation for a proof status.
class TrustProofCopy {
  static String label(BuildContext context, ProofStatus status) {
    final l10n = AppLocalizations.of(context);
    switch (status) {
      case ProofStatus.verified:
        return l10n.trustProofVerifiedLabel;
      case ProofStatus.pending:
        return l10n.trustProofPendingLabel;
      case ProofStatus.warning:
        return l10n.trustProofWarningLabel;
      case ProofStatus.revoked:
        return l10n.trustProofRevokedLabel;
      case ProofStatus.unknown:
        return l10n.trustProofUnknownLabel;
    }
  }

  /// Prefers the app's own translation. The server's [PledgeProof.summary] is
  /// unaccented Vietnamese with no English variant, so it is only used when the
  /// status itself is unknown to this build.
  static String summary(BuildContext context, PledgeProof proof) {
    final l10n = AppLocalizations.of(context);
    switch (proof.status) {
      case ProofStatus.verified:
        return l10n.trustProofVerifiedSummary;
      case ProofStatus.pending:
        return l10n.trustProofPendingSummary;
      case ProofStatus.warning:
        return l10n.trustProofWarningSummary;
      case ProofStatus.revoked:
        return l10n.trustProofRevokedSummary;
      case ProofStatus.unknown:
        return proof.summary.isNotEmpty
            ? proof.summary
            : l10n.trustProofUnknownSummary;
    }
  }
}

/// Compact badge showing the server's blockchain verdict for a pledge.
///
/// Whether the badge appears at all is the server's call: it sets
/// `hide_trust_badge` in `recommendedActions` for revoked pledges, and this
/// widget honours that rather than deciding for itself.
class TrustBadge extends StatelessWidget {
  final PledgeProof? proof;
  final VoidCallback? onTap;

  /// Show the badge even when the server asked for it to be hidden. Used by the
  /// proof screen, where hiding the verdict would leave the page blank.
  final bool ignoreHideAction;

  /// The verdict to draw when there is no proof object at all.
  final ProofStatus? _absentStatus;

  const TrustBadge({
    super.key,
    required PledgeProof this.proof,
    this.onTap,
    this.ignoreHideAction = false,
  }) : _absentStatus = null;

  /// The same badge for a product whose chain has not answered yet.
  ///
  /// The product screen used to render nothing when there was no proof, so a
  /// buyer could not tell a record still being anchored from a product with no
  /// record at all - on the one screen this product exists to make legible.
  const TrustBadge.absent({super.key, required bool loading, this.onTap})
    : proof = null,
      ignoreHideAction = true,
      _absentStatus = loading ? ProofStatus.pending : ProofStatus.unknown;

  ProofStatus get _status => proof?.status ?? _absentStatus!;

  @override
  Widget build(BuildContext context) {
    final current = proof;
    if (!ignoreHideAction && current != null && !current.showBadge) {
      return const SizedBox.shrink();
    }

    final style = _styles[_status]!;
    final label = TrustProofCopy.label(context, _status);

    final badge = DecoratedBox(
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        // 14 vertical, not 6: with a tap target on it this has to clear the
        // 48dp Material floor, and it was 28.
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: onTap == null ? 6 : 14,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(style.icon, size: 16, color: style.foreground),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: style.foreground,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 2),
              Icon(Icons.chevron_right, size: 16, color: style.foreground),
            ],
          ],
        ),
      ),
    );

    return Semantics(
      button: onTap != null,
      label: label,
      child: onTap == null
          ? badge
          : InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(999),
              child: badge,
            ),
    );
  }
}
