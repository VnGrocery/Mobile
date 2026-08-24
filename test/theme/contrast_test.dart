import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Contrast is a product requirement here, not a nicety: PRODUCT.md puts the
/// user one-handed at a market stall in the sun. These pairs were all measured
/// failing at some point; the numbers keep them from drifting back.
double _luminance(Color color) {
  double channel(double value) => value <= 0.03928
      ? value / 12.92
      : math.pow((value + 0.055) / 1.055, 2.4) as double;

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

double contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  const white = Color(0xFFFFFFFF);
  final lightCard = AppPalette.light.card;
  final darkCard = AppPalette.dark.card;
  final darkBg = AppPalette.dark.appBackground;

  group('body and label text clears 4.5:1', () {
    test('secondary text, light', () {
      expect(
        contrast(AppColors.textSecondary, white),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppColors.textSecondary, lightCard),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.light.textSecondary, lightCard),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('secondary text, dark', () {
      expect(
        contrast(AppPalette.dark.textSecondary, darkCard),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.dark.textSecondary, darkBg),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('the icon and label grey, which used to be 2.9:1', () {
      expect(contrast(AppColors.gray, white), greaterThanOrEqualTo(4.5));
      expect(contrast(AppColors.gray, lightCard), greaterThanOrEqualTo(4.5));
    });

    test('white on the filled green, and green on white', () {
      // The brand green under white text measured 3.04:1 and green-on-white
      // text 3.44:1; primaryGreenInk exists for exactly these two cases.
      expect(
        contrast(white, AppColors.primaryGreenInk),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppColors.primaryGreenInk, white),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  group('large figures clear 3:1', () {
    test('metric values on the grey card', () {
      // 22px w900 counts as large text.
      expect(
        contrast(AppColors.trustGreen, lightCard),
        greaterThanOrEqualTo(3),
      );
      expect(
        contrast(AppColors.warningText, lightCard),
        greaterThanOrEqualTo(3),
      );
      expect(contrast(AppColors.trustGreen, darkCard), greaterThanOrEqualTo(3));
    });

    test('the price red, which only ever renders bold', () {
      expect(contrast(AppColors.priceRed, white), greaterThanOrEqualTo(3));
      expect(contrast(AppColors.priceRed, darkBg), greaterThanOrEqualTo(3));
    });
  });

  group('green and orange that carry text follow the theme', () {
    test('light ink reads on white and on the card', () {
      expect(
        contrast(AppPalette.light.greenInk, white),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.light.greenInk, lightCard),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.light.warnInk, lightCard),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('dark ink reads on the dark canvas', () {
      // The light ink measures 2.8:1 on #0B100D, which is how the outlined
      // buttons went dim the first time this split was made.
      expect(
        contrast(AppPalette.dark.greenInk, darkBg),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.dark.greenInk, darkCard),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.dark.warnInk, darkCard),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  group('metadata grey, the smallest type in the app', () {
    // Mốc thời gian, nhãn tile, chú thích đều chạy ở 11px trên bốn bề mặt
    // khác nhau. Cỡ nhỏ nhất phải là cỡ được kiểm kỹ nhất, chứ không phải cỡ
    // duy nhất chưa ai đo.
    test('light tertiary reads on every surface it lands on', () {
      expect(
        contrast(AppPalette.light.textTertiary, white),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.light.textTertiary, lightCard),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.light.textTertiary, AppPalette.light.mutedSurface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.light.textTertiary, AppPalette.light.warningBg),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('dark tertiary reads on every surface it lands on', () {
      expect(
        contrast(AppPalette.dark.textTertiary, darkBg),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.dark.textTertiary, darkCard),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.dark.textTertiary, AppPalette.dark.mutedSurface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.dark.textTertiary, AppPalette.dark.elevatedCard),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  group('secondary text on the warning surface', () {
    // Nhãn kiểm duyệt bình luận đặt chữ phụ lên nền cam nhạt — cặp này chưa
    // từng được đo trước khi có băng thông báo đó.
    test('light', () {
      expect(
        contrast(AppPalette.light.textSecondary, AppPalette.light.warningBg),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.light.warnInk, AppPalette.light.warningBg),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('dark', () {
      expect(
        contrast(AppPalette.dark.textSecondary, AppPalette.dark.warningBg),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(AppPalette.dark.warnInk, AppPalette.dark.warningBg),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  test('the filled button never goes back to the paint green', () {
    // Chữ trắng trên #23AA49 là 3.04:1. Theme đã đặt đúng primaryGreenInk;
    // test này chặn việc một màn hình lẻ ghi đè ngược lại.
    expect(
      contrast(white, AppColors.primaryGreenInk),
      greaterThanOrEqualTo(4.5),
    );
    expect(contrast(white, AppColors.primaryGreen), lessThan(4.5));
  });

  test('the brand green stays the brand green for paint', () {
    // Icons, borders and chart lines only need 3:1, and primaryGreen is the
    // identity: this test is here so the ink/paint split is not "fixed" by
    // flattening both to one value.
    expect(AppColors.primaryGreen, const Color(0xFF23AA49));
    expect(contrast(AppColors.primaryGreen, white), greaterThanOrEqualTo(3));
  });
}
