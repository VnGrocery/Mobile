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

  // Giá tiền (đỏ hồng grocery)
  static const Color priceRed = Color(0xFFFF324B);

  // Điểm chất lượng / badge
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color trustGreen = Color(0xFF2E7D32);
  static const Color trustGreenBg = Color(0xFFE8F5E9);
  static const Color warningBg = Color(0xFFFFF3E0);

  // Nền & bề mặt grocery
  static const Color screenBg = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFF3F5F7); // card xám phẳng
  static const Color lightGray = Color(0xFFF3F5F7);
  static const Color darkGray = Color(0xFF333333);
  static const Color gray = Color(0xFF979899);
  static const Color textSecondary = Color(0xFF979899);
  static const Color border = Color(0xFFF1F1F5);
}
