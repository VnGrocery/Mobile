import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_colors.dart';

class AuthSegmentItem extends StatelessWidget {
  final String label;
  final int index;
  final bool active;
  final ValueChanged<int> onTap;

  const AuthSegmentItem({
    super.key,
    required this.label,
    required this.index,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(23),
        onTap: () => onTap(index),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? AppColors.primaryGreen : Colors.grey,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
