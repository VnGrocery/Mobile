import 'package:flutter/material.dart';

/// Bảng màu theo Template grocery gốc.
/// `meatRed` được giữ tên nhưng mang giá trị XANH LÁ (primary grocery)
/// để các màn hình đã port không phải đổi tên hàng loạt.
class AppColors {
  // Primary grocery (xanh lá)
  static const Color meatRed = Color(0xFF23AA49);
  static const Color primaryGreen = Color(0xFF23AA49);
  static const Color primaryGreenDark = Color(0xFF1E8A3C);

  // Giá tiền (đỏ hồng grocery)
  static const Color priceRed = Color(0xFFFF324B);

  // Điểm chất lượng / badge
  static const Color freshGreen = Color(0xFF23AA49);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color trustGreen = Color(0xFF2E7D32);
  static const Color trustGreenBg = Color(0xFFE8F5E9);
  static const Color warningBg = Color(0xFFFFF3E0);

  // Nền & bề mặt grocery
  static const Color screenBg = Colors.white;
  static const Color card = Color(0xFFF3F5F7); // card xám phẳng
  static const Color lightGray = Color(0xFFF3F5F7);
  static const Color darkGray = Color(0xFF333333);
  static const Color gray = Color(0xFF979899);
  static const Color textSecondary = Color(0xFF979899);
  static const Color border = Color(0xFFF1F1F5);

  /// Màu điểm tươi (3 mức) — theo MockData.getFreshnessColor.
  static Color freshnessColor(int score) {
    if (score >= 80) return freshGreen;
    if (score >= 50) return warningOrange;
    return priceRed;
  }
}
