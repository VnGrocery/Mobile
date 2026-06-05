import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'VnGrocery',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w900,
          color: AppColors.meatRed,
        ),
      ),
    );
  }
}

class AuthSubtitle extends StatelessWidget {
  final bool register;

  const AuthSubtitle({super.key, required this.register});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        register
            ? AppLocalizations.of(context).authRegisterSubtitle
            : AppLocalizations.of(context).authWelcomeBack,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

class AuthInfoCard extends StatelessWidget {
  final bool register;

  const AuthInfoCard({super.key, required this.register});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: scheme.surface,
            child: Icon(
              register ? Icons.person_add_alt : Icons.verified_user,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              register
                  ? AppLocalizations.of(context).authRegisterInfo
                  : AppLocalizations.of(context).authLoginInfo,
              style: const TextStyle(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
