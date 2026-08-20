import 'json_helpers.dart';

/// Trust bands the server derives from [TrustSummary.score].
///
/// Thresholds live on the server (85 / 70 / 55); the app only names them, so the
/// two cannot disagree about where a shop sits.
enum TrustGrade {
  excellent,
  good,
  watch,
  risk;

  static TrustGrade parse(Object? value) {
    switch (value?.toString()) {
      case 'excellent':
        return TrustGrade.excellent;
      case 'good':
        return TrustGrade.good;
      case 'watch':
        return TrustGrade.watch;
      default:
        return TrustGrade.risk;
    }
  }
}

/// One component of the overall trust score, ready to render as a bar.
class TrustComponent {
  final String key;
  final double score;

  const TrustComponent(this.key, this.score);
}

/// The shop-level trust verdict the server attaches to every shop response.
class TrustSummary {
  final bool hasPledges;
  final int pledgeCount;
  final String latestPledgeId;
  final double score;
  final TrustGrade grade;
  final String formulaVersion;

  final double pledgeScore;
  final double reviewScore;
  final double buyerCheckScore;
  final double consistencyScore;
  final double recencyScore;
  final double coverageScore;

  final int buyerCheckCount;
  final int trustedCheckCount;
  final int highRiskCheckCount;

  /// Machine-readable codes explaining the score, translated by the UI.
  final List<String> reasons;

  const TrustSummary({
    this.hasPledges = false,
    this.pledgeCount = 0,
    this.latestPledgeId = '',
    this.score = 0,
    this.grade = TrustGrade.risk,
    this.formulaVersion = '',
    this.pledgeScore = 0,
    this.reviewScore = 0,
    this.buyerCheckScore = 0,
    this.consistencyScore = 0,
    this.recencyScore = 0,
    this.coverageScore = 0,
    this.buyerCheckCount = 0,
    this.trustedCheckCount = 0,
    this.highRiskCheckCount = 0,
    this.reasons = const [],
  });

  /// True when the server has enough signal for the score to mean anything.
  /// A brand new shop scores 0 with no pledges, which should read as "no data
  /// yet" rather than "untrustworthy".
  bool get hasData => hasPledges || pledgeCount > 0 || buyerCheckCount > 0;

  /// The six sub-scores in the order the server documents them.
  List<TrustComponent> get components => [
    TrustComponent('pledge', pledgeScore),
    TrustComponent('review', reviewScore),
    TrustComponent('buyerCheck', buyerCheckScore),
    TrustComponent('consistency', consistencyScore),
    TrustComponent('recency', recencyScore),
    TrustComponent('coverage', coverageScore),
  ];

  static double _num(Object? value) => (value as num?)?.toDouble() ?? 0;
  static int _int(Object? value) => (value as num?)?.toInt() ?? 0;

  factory TrustSummary.fromJson(Map<String, Object?> json) {
    return TrustSummary(
      hasPledges: json['hasPledges'] == true,
      pledgeCount: _int(json['pledgeCount']),
      latestPledgeId: json['latestPledgeId']?.toString() ?? '',
      score: _num(json['score']),
      grade: TrustGrade.parse(json['grade']),
      formulaVersion: json['formulaVersion']?.toString() ?? '',
      pledgeScore: _num(json['pledgeScore']),
      reviewScore: _num(json['reviewScore']),
      buyerCheckScore: _num(json['buyerCheckScore']),
      consistencyScore: _num(json['consistencyScore']),
      recencyScore: _num(json['recencyScore']),
      coverageScore: _num(json['coverageScore']),
      buyerCheckCount: _int(json['buyerCheckCount']),
      trustedCheckCount: _int(json['trustedCheckCount']),
      highRiskCheckCount: _int(json['highRiskCheckCount']),
      reasons: stringList(json['reasons']),
    );
  }

  Map<String, Object?> toJson() => {
    'hasPledges': hasPledges,
    'pledgeCount': pledgeCount,
    'latestPledgeId': latestPledgeId,
    'score': score,
    'grade': grade.name,
    'formulaVersion': formulaVersion,
    'pledgeScore': pledgeScore,
    'reviewScore': reviewScore,
    'buyerCheckScore': buyerCheckScore,
    'consistencyScore': consistencyScore,
    'recencyScore': recencyScore,
    'coverageScore': coverageScore,
    'buyerCheckCount': buyerCheckCount,
    'trustedCheckCount': trustedCheckCount,
    'highRiskCheckCount': highRiskCheckCount,
    'reasons': reasons,
  };
}
