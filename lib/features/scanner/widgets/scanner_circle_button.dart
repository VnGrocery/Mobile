import 'package:flutter/material.dart';

class ScannerCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  /// What TalkBack says. An icon-only control announced as "button" tells a
  /// blind user nothing, and these two are the camera's only way out.
  final String label;

  const ScannerCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.3),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onTap,
        tooltip: label,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
