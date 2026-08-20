import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/widgets/cart_badge_button.dart';
import 'package:vngrocery/features/cart/controllers/cart_bloc.dart';
import 'package:vngrocery/features/cart/controllers/cart_state.dart';
import 'package:vngrocery/core/widgets/user_avatar.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onOpenMenu;

  /// Name of the area the reader is in. Empty while unknown.
  final String areaName;

  /// True once the app has a position but no name for it — the ranking works,
  /// only the label is missing.
  final bool located;

  /// Retries locating. The chip used to carry a dropdown arrow suggesting a
  /// picker that did not exist.
  final VoidCallback? onRefreshLocation;

  const HomeHeader({
    super.key,
    required this.userName,
    this.onOpenMenu,
    this.areaName = '',
    this.located = false,
    this.onRefreshLocation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: onOpenMenu,
            child: UserAvatar(name: userName),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeGreeting,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _LocationChip(
            label: areaName.isNotEmpty
                ? areaName
                : located
                ? l10n.homeLocationNearby
                : l10n.homeLocationUnknown,
            located: located,
            onTap: onRefreshLocation,
          ),
          const SizedBox(width: 8),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return CartBadgeButton(
                itemCount: state.itemCount,
                onTap: () => Navigator.pushNamed(context, Routes.cart),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Shows where the reader is, and offers to look again when it does not know.
class _LocationChip extends StatelessWidget {
  final String label;
  final bool located;
  final VoidCallback? onTap;

  const _LocationChip({required this.label, required this.located, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                located ? Icons.location_on : Icons.location_off_outlined,
                color: located
                    ? AppColors.primaryGreen
                    : AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 4),
              ConstrainedBox(
                // A district name can be long ("Thành phố Thủ Đức") and must
                // not push the cart button off the row.
                constraints: const BoxConstraints(maxWidth: 110),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: located ? null : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
