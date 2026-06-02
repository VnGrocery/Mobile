import 'package:flutter/material.dart';

class SideMenuHalo extends StatelessWidget {
  const SideMenuHalo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.10),
      ),
    );
  }
}
