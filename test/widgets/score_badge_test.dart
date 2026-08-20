import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/widgets/score_badge.dart';

void main() {
  group('scoreTrustColor', () {
    // The server validates freshness as 0-10. The thresholds used to be 90/70,
    // written for a 0-100 scale, so every real product landed in the red band.
    test('a fresh product reads as good, not as a failure', () {
      expect(scoreTrustColor(9.2), AppColors.primaryGreen);
      expect(scoreTrustColor(9), AppColors.primaryGreen);
    });

    test('the middle of the scale warns', () {
      expect(scoreTrustColor(8.5), AppColors.warningOrange);
      expect(scoreTrustColor(7), AppColors.warningOrange);
    });

    test('a low score is flagged', () {
      expect(scoreTrustColor(6.9), AppColors.priceRed);
      expect(scoreTrustColor(0), AppColors.priceRed);
    });

    test('the ring is full at the top of the scale', () {
      expect(maxScore, 10);
    });
  });
}
