import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/widgets/cart_badge_button.dart';
import 'package:vngrocery/features/cart/controllers/cart_bloc.dart';
import 'package:vngrocery/features/cart/controllers/cart_state.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onOpenMenu;

  const HomeHeader({
    super.key,
    required this.userName,
    this.onOpenMenu,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: onOpenMenu,
            child: ClipOval(
              child: Image.asset(
                'assets/images/user.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => CircleAvatar(
                  radius: 24,
                  backgroundColor: palette.card,
                  child: const Icon(
                    Icons.person,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.primaryGreen,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.homeLocationDistrict1,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primaryGreen,
                  size: 16,
                ),
              ],
            ),
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
