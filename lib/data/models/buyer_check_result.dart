import 'json_helpers.dart';

/// Result of a buyer verifying a product against the seller's pledge.
///
/// The comparison fields are the point of the whole feature: they say whether
/// what the buyer measured matches what the seller promised.
class BuyerCheckResult {
  final int actualScore;
  final String locationStatus;
  final String verdict;

  /// True when the server considers this check consistent with the pledge.
  final bool trusted;

  /// False when the product had no pledge to compare against, in which case the
  /// comparison fields carry no meaning.
  final bool hasPledge;

  final double pledgedScore;
  final double scoreDelta;
  final String pledgedCategory;
  final String actualCategory;
  final double actualConfidence;
  final bool categoryMatch;

  /// Machine-readable explanations, translated by the UI.
  final List<String> reasons;

  const BuyerCheckResult({
    required this.actualScore,
    required this.locationStatus,
    required this.verdict,
    this.trusted = false,
    this.hasPledge = false,
    this.pledgedScore = 0,
    this.scoreDelta = 0,
    this.pledgedCategory = '',
    this.actualCategory = '',
    this.actualConfidence = 0,
    this.categoryMatch = false,
    this.reasons = const [],
  });

  /// Whether there is a pledge to show the buyer a side-by-side comparison for.
  bool get canCompare => hasPledge && pledgedScore > 0;

  /// The measured score fell short of what was pledged.
  bool get isWorseThanPledged => scoreDelta < 0;

  factory BuyerCheckResult.fromJson(Map<String, Object?> json) {
    return BuyerCheckResult(
      actualScore: (json['actualScore'] as num).round(),
      locationStatus: json['locationStatus'] as String,
      verdict: json['verdict'] as String,
      trusted: json['trusted'] == true,
      hasPledge: json['hasPledge'] == true,
      pledgedScore: (json['pledgedScore'] as num?)?.toDouble() ?? 0,
      scoreDelta: (json['scoreDelta'] as num?)?.toDouble() ?? 0,
      pledgedCategory: json['pledgedCategory']?.toString() ?? '',
      actualCategory: json['actualCategory']?.toString() ?? '',
      actualConfidence: (json['actualConfidence'] as num?)?.toDouble() ?? 0,
      categoryMatch: json['categoryMatch'] == true,
      reasons: stringList(json['reasons']),
    );
  }

  Map<String, Object?> toJson() => {
    'actualScore': actualScore,
    'locationStatus': locationStatus,
    'verdict': verdict,
    'trusted': trusted,
    'hasPledge': hasPledge,
    'pledgedScore': pledgedScore,
    'scoreDelta': scoreDelta,
    'pledgedCategory': pledgedCategory,
    'actualCategory': actualCategory,
    'actualConfidence': actualConfidence,
    'categoryMatch': categoryMatch,
    'reasons': reasons,
  };
}
