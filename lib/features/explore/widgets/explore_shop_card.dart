import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/widgets/common.dart';

class ExploreShopCard extends StatelessWidget {
  final Shop shop;
  final bool selected;
  final VoidCallback onTap;

  const ExploreShopCard({
    super.key,
    required this.shop,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Card(
      color: selected ? palette.positiveBg : palette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? AppColors.primaryGreen : Colors.transparent,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: () => Navigator.pushNamed(
          context,
          Routes.storeDetail,
          arguments: shop.id,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const GrayBox(
                size: 70,
                radius: 12,
                icon: Icons.store,
                iconSize: 32,
                iconColor: AppColors.meatRed,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      shop.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.trustGreenBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppColors.warningOrange,
                                size: 12,
                              ),
                              Text(
                                ' ${shop.rating} điểm đánh giá',
                                style: const TextStyle(
                                  color: AppColors.trustGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (shop.reviewCount > 100)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.meatRed.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Đánh giá tốt',
                              style: TextStyle(
                                color: AppColors.meatRed,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                selected ? Icons.place : Icons.chevron_right,
                color: selected ? AppColors.primaryGreen : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
