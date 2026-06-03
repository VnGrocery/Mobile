import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_colors.dart';

class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'VnGrocery',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w900,
          color: AppColors.meatRed,
        ),
      ),
    );
  }
}

class AuthSubtitle extends StatelessWidget {
  final bool register;

  const AuthSubtitle({super.key, required this.register});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        register
            ? 'Tạo tài khoản để lưu kiểm chứng sản phẩm'
            : 'Chào mừng bạn quay lại',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

class AuthInfoCard extends StatelessWidget {
  final bool register;

  const AuthInfoCard({super.key, required this.register});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: scheme.surface,
            child: Icon(
              register ? Icons.person_add_alt : Icons.verified_user,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              register
                  ? 'Tài khoản demo sẽ dùng dữ liệu ảo cho đến khi gắn API thật.'
                  : 'Đăng nhập demo để kiểm tra sản phẩm, xem bản đồ và giá tại cửa hàng.',
              style: const TextStyle(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
