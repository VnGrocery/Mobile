import 'package:flutter/material.dart';

import 'package:vngrocery/core/ui/app_sheet.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class AccountHelpSheet extends StatelessWidget {
  const AccountHelpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: AppSheetHandle()),
          SizedBox(height: 18),
          Text(
            'Hỗ trợ',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          AccountHelpRow(
            icon: Icons.qr_code_scanner,
            title: 'Quét sản phẩm',
            body: 'Chụp sản phẩm và mã QR để kiểm tra dữ liệu đã ghi nhận.',
          ),
          AccountHelpRow(
            icon: Icons.storefront,
            title: 'Cửa hàng',
            body: 'Xem danh sách cửa hàng, đánh giá và sản phẩm gần đây.',
          ),
          AccountHelpRow(
            icon: Icons.mail,
            title: 'Liên hệ',
            body: 'Gửi email tới support@vngrocery.local khi cần hỗ trợ.',
          ),
        ],
      ),
    );
  }
}

class AccountHelpRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const AccountHelpRow({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: context.palette.positiveBg,
            child: Icon(icon, size: 18, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
