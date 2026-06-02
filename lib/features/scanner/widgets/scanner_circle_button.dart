import 'package:flutter/material.dart';

class ScannerCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ScannerCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.3),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
