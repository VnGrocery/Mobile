import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class SellerShopFootnote extends StatelessWidget {
  const SellerShopFootnote({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Thông tin này dùng để hiển thị trên trang cửa hàng và tem sản phẩm.',
      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
    );
  }
}
