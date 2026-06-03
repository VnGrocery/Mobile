import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';

class CartExpiryBanner extends StatelessWidget {
  const CartExpiryBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.palette.warningBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.schedule, color: AppColors.warningOrange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sản phẩm trong giỏ chỉ được giữ 24 giờ để tính tiền và kiểm tra voucher.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
