import 'package:flutter/material.dart';

import '../../../data/models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';

class StoreHeader extends StatelessWidget {
  final Shop shop;

  const StoreHeader({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 120,
          color: AppColors.meatRed.withValues(alpha: 0.1),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: palette.elevatedCard,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: palette.mutedSurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.store, size: 40, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                shop.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: palette.positiveBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified,
                      color: AppColors.trustGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${shop.rating} điểm đánh giá',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.trustGreen,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Text(
                  shop.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
