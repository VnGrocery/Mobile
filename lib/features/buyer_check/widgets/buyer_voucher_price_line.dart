import 'package:flutter/material.dart';
import 'package:vngrocery/theme/app_palette.dart';

class PriceLine extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const PriceLine({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: context.palette.textSecondary)),
        ),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
