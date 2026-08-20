import 'package:flutter/material.dart';
import 'package:vngrocery/core/widgets/user_avatar.dart';
import 'package:vngrocery/l10n/app_localizations.dart';


class SideMenuProfile extends StatelessWidget {
  final String name;
  final bool isSeller;

  const SideMenuProfile({
    super.key,
    required this.name,
    required this.isSeller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        UserAvatar(name: name, radius: 27),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                isSeller ? l10n.roleSeller : l10n.roleBuyer,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
