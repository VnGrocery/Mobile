import 'package:flutter/material.dart';

class SellerDashboardHeader extends StatelessWidget {
  final String shopName;

  const SellerDashboardHeader({super.key, required this.shopName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          shopName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          'Chế độ seller - dữ liệu demo từ hook',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
