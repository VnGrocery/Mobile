import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_palette.dart';

class AnimatedContentShell extends StatelessWidget {
  final bool open;
  final int selectedIndex;
  final List<Widget> tabs;

  const AnimatedContentShell({
    super.key,
    required this.open,
    required this.selectedIndex,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(open ? 30 : 0);

    return AnimatedSlide(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutBack,
      offset: open ? const Offset(0.68, 0.035) : Offset.zero,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutBack,
        alignment: Alignment.centerLeft,
        scale: open ? 0.86 : 1,
        child: AnimatedPhysicalModel(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          color: context.palette.appBackground,
          elevation: open ? 18 : 0,
          shadowColor: Colors.black.withValues(alpha: 0.28),
          shape: BoxShape.rectangle,
          borderRadius: radius,
          child: AbsorbPointer(
            absorbing: open,
            child: ClipRRect(
              borderRadius: radius,
              child: Scaffold(
                backgroundColor: context.palette.appBackground,
                body: IndexedStack(
                  index: selectedIndex,
                  children: tabs,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
