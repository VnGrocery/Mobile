import 'package:flutter/material.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Ô vuông xám bo góc (placeholder ảnh) có icon ở giữa.
class GrayBox extends StatelessWidget {
  final double size;
  final double radius;
  final IconData icon;
  final double? iconSize;
  final Color iconColor;
  const GrayBox({
    super.key,
    this.size = 70,
    this.radius = 8,
    this.icon = Icons.image,
    this.iconSize,
    this.iconColor = AppColors.gray,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.palette.mutedSurface,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, color: iconColor, size: iconSize ?? size * 0.4),
    );
  }
}

/// Hàng thông tin: icon xám + (nhãn nhỏ / giá trị).
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.gray),
          const SizedBox(width: 12),
          // Expanded: the value is server text - a shop UUID, a seller's own
          // freshness note - and it used to run off the edge of the row.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: AppColors.gray),
                ),
                Text(
                  value,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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
