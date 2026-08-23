import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/widgets/score_badge.dart';

void main() {
  group('scoreTrustColor', () {
    // The server validates freshness as 0-10. The thresholds used to be 90/70,
    // written for a 0-100 scale, so every real product landed in the red band.
    test('a fresh product reads as good, not as a failure', () {
      // trustGreen, not the brand green: this is text on a light card, where
      // #23AA49 only reaches 2.78:1.
      expect(scoreTrustColor(9.2), AppColors.trustGreen);
      expect(scoreTrustColor(9), AppColors.trustGreen);
    });

    test('an ordinary score is not a warning', () {
      // 7-8.9 used to be orange, so a perfectly good 8.0 wore the app's
      // warning colour inside a card framed as reassuring.
      expect(scoreTrustColor(8.5), AppColors.trustGreen);
      expect(scoreTrustColor(7), AppColors.trustGreen);
    });

    test('the middle of the scale warns', () {
      expect(scoreTrustColor(6.9), AppColors.warningText);
      expect(scoreTrustColor(5), AppColors.warningText);
    });

    test('a low score is flagged', () {
      expect(scoreTrustColor(4.9), AppColors.priceRed);
      expect(scoreTrustColor(0), AppColors.priceRed);
    });

    test('the ring is full at the top of the scale', () {
      expect(maxScore, 10);
    });
  });
}
