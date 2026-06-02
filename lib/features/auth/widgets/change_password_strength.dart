import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

String passwordStrengthLabel(int strength) {
  return switch (strength) {
    0 || 1 => 'Mật khẩu mới còn yếu',
    2 || 3 => 'Mật khẩu mới ở mức khá',
    _ => 'Mật khẩu mới mạnh',
  };
}

Color passwordStrengthColor(int strength) {
  return switch (strength) {
    0 || 1 => AppColors.priceRed,
    2 || 3 => AppColors.warningOrange,
    _ => AppColors.primaryGreen,
  };
}
