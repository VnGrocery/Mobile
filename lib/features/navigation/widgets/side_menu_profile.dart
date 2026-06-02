import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class SideMenuProfile extends StatelessWidget {
  final String name;
  final bool isSeller;

  const SideMenuProfile({
    super.key,
    required this.name,
    required this.isSeller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            'assets/images/user.png',
            width: 54,
            height: 54,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const CircleAvatar(
              radius: 27,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.primaryGreen),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                isSeller ? 'Người bán' : 'Người mua',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
