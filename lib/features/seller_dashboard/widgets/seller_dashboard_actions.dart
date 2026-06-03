import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_colors.dart';

class CreateSellerPledgeCard extends StatelessWidget {
  final bool canCreatePledge;
  final VoidCallback onTap;

  const CreateSellerPledgeCard({
    super.key,
    required this.canCreatePledge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryGreen,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: canCreatePledge ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.add_a_photo, color: Colors.white),
                    const SizedBox(height: 12),
                    const Text(
                      'Thêm ghi nhận sản phẩm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      canCreatePledge
                          ? 'Chọn sản phẩm và lưu thông tin tại quầy.'
                          : 'Cần tạo sản phẩm trước khi ghi nhận.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_forward, color: AppColors.primaryGreen),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SellerDashboardActions extends StatelessWidget {
  final VoidCallback onOpenProducts;
  final VoidCallback onOpenHistory;

  const SellerDashboardActions({
    super.key,
    required this.onOpenProducts,
    required this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onOpenProducts,
            icon: const Icon(Icons.inventory_2),
            label: const Text('Sản phẩm'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onOpenHistory,
            icon: const Icon(Icons.history),
            label: const Text('Lịch sử'),
          ),
        ),
      ],
    );
  }
}
