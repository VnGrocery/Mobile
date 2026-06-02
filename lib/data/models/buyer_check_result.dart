part of '../models.dart';

class BuyerCheckResult {
  final int actualScore;
  final String locationStatus;
  final String verdict;

  const BuyerCheckResult({
    required this.actualScore,
    required this.locationStatus,
    required this.verdict,
  });

  factory BuyerCheckResult.fromJson(Map<String, Object?> json) {
    return BuyerCheckResult(
      actualScore: (json['actualScore'] as num).toInt(),
      locationStatus: json['locationStatus'] as String,
      verdict: json['verdict'] as String,
    );
  }

  Map<String, Object?> toJson() => {
        'actualScore': actualScore,
        'locationStatus': locationStatus,
        'verdict': verdict,
      };
}
