import 'package:flutter/material.dart';

class SideMenuCloseOverlay extends StatelessWidget {
  final VoidCallback onTap;
  final GestureDragUpdateCallback onDragUpdate;
  final VoidCallback onDragEnd;

  const SideMenuCloseOverlay({
    super.key,
    required this.onTap,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 252,
      top: 24,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        onHorizontalDragUpdate: onDragUpdate,
        onHorizontalDragEnd: (_) => onDragEnd(),
        onHorizontalDragCancel: onDragEnd,
      ),
    );
  }
}

class SideMenuOpenDragHandle extends StatelessWidget {
  final GestureDragUpdateCallback onDragUpdate;
  final VoidCallback onDragEnd;

  const SideMenuOpenDragHandle({
    super.key,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 42,
      top: 0,
      bottom: 0,
      width: 54,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: onDragUpdate,
        onHorizontalDragEnd: (_) => onDragEnd(),
        onHorizontalDragCancel: onDragEnd,
      ),
    );
  }
}
