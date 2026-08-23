import 'package:flutter/material.dart';

/// Bảng màu theo Template grocery gốc.
///
/// Trước đây có ba hằng cùng một giá trị xanh lá: `meatRed` (tên nói đỏ,
/// giá trị xanh — di sản từ lúc app chỉ bán thịt), `freshGreen` và
/// `primaryGreen`. Đọc code không đoán được màu thật, nên nay chỉ còn
/// `primaryGreen`.
class AppColors {
  // Primary grocery (xanh lá)
  static const Color primaryGreen = Color(0xFF23AA49);
  static const Color primaryGreenDark = Color(0xFF1E8A3C);

  /// Green for anything carrying text: filled buttons, the big action cards,
  /// green labels on a light surface.
  ///
  /// primaryGreen is the brand green for paint - icons, borders, chart lines,
  /// chips - where 3:1 is the bar and it clears it. Under white text it only
  /// reaches 3.04:1, and green-on-white text only 3.44:1, both under the 4.5:1
  /// this app needs at a market stall in the sun. This one is 5.4:1 either way
  /// and is the same hue, half a step deeper.
  static const Color primaryGreenInk = Color(0xFF157A33);

  // Giá tiền (đỏ hồng grocery)
  static const Color priceRed = Color(0xFFFF324B);

  // Điểm chất lượng / badge
  static const Color warningOrange = Color(0xFFFF9800);

  /// Warning colour for *text* on a light surface. warningOrange is for icons,
  /// badges and fills; as 22px type on the grey card it measures 1.97:1.
  static const Color warningText = Color(0xFFA65200);
  /// Green for text and numbers on a light surface. primaryGreen is the brand
  /// green for fills and icons; at text sizes on the grey card it only reaches
  /// 2.78:1, so figures use this instead (4.7:1).
  static const Color trustGreen = Color(0xFF2E7D32);
  static const Color trustGreenBg = Color(0xFFE8F5E9);
  static const Color warningBg = Color(0xFFFFF3E0);

  // Nền & bề mặt grocery
  static const Color screenBg = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFF3F5F7); // card xám phẳng
  static const Color lightGray = Color(0xFFF3F5F7);
  static const Color darkGray = Color(0xFF333333);
  /// Icon and label grey. Was 0xFF979899, which measured 2.9:1 on white and
  /// 2.6:1 on the grey card - the same failure textSecondary was raised for,
  /// left behind in InfoRow, the proof badge and the map search field.
  static const Color gray = Color(0xFF626864);
  /// Nhãn và siêu dữ liệu. Trước là 0xFF979899, chỉ đạt ~2.6:1 trên nền thẻ
  /// xám 0xFFF3F5F7 - dưới chuẩn 4.5:1 và gần như mất chữ khi cầm ngoài nắng,
  /// đúng bối cảnh dùng thật của app. Giá trị mới đạt 5.2:1 trên nền thẻ và
  /// 5.7:1 trên nền trắng.
  static const Color textSecondary = Color(0xFF626864);
  static const Color border = Color(0xFFF1F1F5);
}
