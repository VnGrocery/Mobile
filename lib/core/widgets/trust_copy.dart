import 'package:flutter/widgets.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

/// Turns the server's machine-readable trust codes into localised text.
///
/// The server owns the scoring; the app only names what it produced. Unknown
/// codes are dropped rather than shown raw, so a newer server never leaks
/// `no_eligible_buyer_checks` into the UI.
class TrustCopy {
  static String grade(BuildContext context, TrustGrade grade) {
    final l10n = AppLocalizations.of(context);
    switch (grade) {
      case TrustGrade.excellent:
        return l10n.trustGradeExcellent;
      case TrustGrade.good:
        return l10n.trustGradeGood;
      case TrustGrade.watch:
        return l10n.trustGradeWatch;
      case TrustGrade.risk:
        return l10n.trustGradeRisk;
    }
  }

  /// Label for a raw `integrityStatus`, reusing the proof-status wording so a
  /// pledge reads the same in the timeline as it does on the product page.
  static String integrityStatus(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context);
    switch (status) {
      case 'anchored':
      case 'reanchored':
        return l10n.trustProofVerifiedLabel;
      case 'pending_anchor':
        return l10n.trustProofPendingLabel;
      case 'mismatch_detected':
        return l10n.trustProofWarningLabel;
      case 'revoked':
        return l10n.trustProofRevokedLabel;
      default:
        return l10n.trustProofUnknownLabel;
    }
  }

  static String component(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context);
    switch (key) {
      case 'pledge':
        return l10n.trustComponentPledge;
      case 'review':
        return l10n.trustComponentReview;
      case 'buyerCheck':
        return l10n.trustComponentBuyerCheck;
      case 'consistency':
        return l10n.trustComponentConsistency;
      case 'recency':
        return l10n.trustComponentRecency;
      case 'coverage':
        return l10n.trustComponentCoverage;
      default:
        return key;
    }
  }

  /// Null for a code this build does not know about.
  static String? reason(BuildContext context, String code) {
    final l10n = AppLocalizations.of(context);
    switch (code) {
      case 'partial_trust_data':
        return l10n.trustReasonPartialTrustData;
      case 'no_customer_reviews':
        return l10n.trustReasonNoCustomerReviews;
      case 'no_buyer_checks':
        return l10n.trustReasonNoBuyerChecks;
      case 'no_eligible_buyer_checks':
        return l10n.trustReasonNoEligibleBuyerChecks;
      case 'buyer_checks_confirmed':
        return l10n.trustReasonBuyerChecksConfirmed;
      case 'buyer_checks_high_risk':
        return l10n.trustReasonBuyerChecksHighRisk;
      case 'buyer_checks_show_consistency_issues':
        return l10n.trustReasonBuyerChecksConsistencyIssues;
      case 'duplicate_buyer_checks_discounted':
        return l10n.trustReasonDuplicateBuyerChecks;
      case 'pledges_consistent_with_buyer_checks':
        return l10n.trustReasonPledgesConsistent;
      case 'limited_consistency_data':
        return l10n.trustReasonLimitedConsistencyData;
      case 'no_consistency_signals':
        return l10n.trustReasonNoConsistencySignals;
      case 'limited_signal_coverage':
        return l10n.trustReasonLimitedSignalCoverage;
      case 'recent_activity_available':
        return l10n.trustReasonRecentActivity;
      case 'no_recent_activity':
        return l10n.trustReasonNoRecentActivity;
      case 'no_pledge':
        return l10n.trustReasonNoPledge;
      case 'no_seller_pledges':
        return l10n.trustReasonNoSellerPledges;
      case 'some_pledges_low_confidence':
        return l10n.trustReasonSomePledgesLowConfidence;
      default:
        return null;
    }
  }

  /// Every reason the app can express, in the order the server sent them.
  static List<String> reasons(BuildContext context, List<String> codes) {
    return codes
        .map((code) => reason(context, code))
        .whereType<String>()
        .toList();
  }
}
