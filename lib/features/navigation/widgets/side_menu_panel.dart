import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/features/navigation/navigation_config.dart';
import 'side_menu_button.dart';
import 'side_menu_footnote.dart';
import 'side_menu_halo.dart';
import 'side_menu_profile.dart';

class SideMenuPanel extends StatelessWidget {
  final bool isSeller;
  final bool open;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const SideMenuPanel({
    super.key,
    required this.isSeller,
    required this.open,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final name = context.watch<SessionCubit>().state.displayName;
    final items = NavigationConfig.sideMenuItems(isSeller);

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      offset: open ? Offset.zero : const Offset(-0.14, 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        opacity: open ? 1 : 0.78,
        child: SafeArea(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 286,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 18, 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                    ),
                    child: Stack(
                      children: [
                        const Positioned(
                          right: -56,
                          top: -44,
                          child: SideMenuHalo(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SideMenuProfile(name: name, isSeller: isSeller),
                              const SizedBox(height: 34),
                              for (var i = 0; i < items.length; i++) ...[
                                SideMenuButton(
                                  icon: items[i].icon,
                                  label: items[i].label,
                                  open: open,
                                  delayIndex: i,
                                  selected: i == selectedIndex,
                                  onTap: () => onSelect(i),
                                  selectorKey: items[i].selectorKey,
                                ),
                                const SizedBox(height: 8),
                              ],
                              const Spacer(),
                              const SideMenuFootnote(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
