import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/account/widgets/account_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/theme/theme_controller.dart';

class AccountTab extends StatefulWidget {
  final double bottomContentInset;
  final ValueChanged<int>? onSelectTab;

  const AccountTab({
    super.key,
    this.bottomContentInset = 0,
    this.onSelectTab,
  });

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  void _selectTab(int index) => widget.onSelectTab?.call(index);

  Future<void> _editProfile(BuildContext context) async {
    final session = context.read<SessionCubit>().state;
    final saved = await showAccountEditProfileSheet(
      context,
      initialName: session.displayName,
      initialEmail: session.email,
      onSave: (name, email) {
        context
            .read<SessionCubit>()
            .updateProfile(displayName: name, email: email);
      },
    );

    if (saved == true && context.mounted) {
      AppFeedback.showSnackBar(
        context,
        AppLocalizations.of(context).accountProfileUpdated,
      );
    }
  }

  void _showHelp(BuildContext context) {
    showAccountHelpSheet(context);
  }

  Future<void> _logout(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.accountLogoutTitle),
        content: Text(l10n.accountLogoutPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.accountLogoutTitle,
              style: const TextStyle(color: AppColors.meatRed),
            ),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<SessionCubit>().logout();
      Navigator.pushNamedAndRemoveUntil(context, Routes.auth, (r) => false);
    }
  }

  void _switchRole(String role) {
    final l10n = AppLocalizations.of(context);
    context.read<SessionCubit>().setRole(role);
    AppFeedback.showSnackBar(
      context,
      role == 'seller'
          ? l10n.accountModeSwitchedSeller
          : l10n.accountModeSwitchedBuyer,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = context.watch<SessionCubit>().state;
    final isSeller = session.isSeller;

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: Text(
          l10n.accountProfileTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: widget.bottomContentInset),
        children: [
          AccountProfileSummary(
            displayName: session.displayName,
            email: session.email,
            isSeller: isSeller,
            onRoleChanged: _switchRole,
          ),
          AccountSectionLabel(l10n.accountCurrentMode),
          AccountModeCard(isSeller: isSeller),
          if (isSeller) ...[
            AccountSectionLabel(l10n.accountSellerManagement),
            AccountMenuItem(
              icon: Icons.inventory_2,
              label: l10n.accountMyProducts,
              onTap: () => _selectTab(1),
            ),
            AccountMenuItem(
              icon: Icons.store,
              label: l10n.accountStoreInfo,
              onTap: () => _selectTab(2),
            ),
          ] else ...[
            AccountSectionLabel(l10n.accountBuyerActivity),
            AccountMenuItem(
              icon: Icons.explore,
              label: l10n.accountExploreStores,
              onTap: () => _selectTab(1),
            ),
            AccountMenuItem(
              icon: Icons.qr_code_scanner,
              label: l10n.accountScanProducts,
              onTap: () => _selectTab(2),
            ),
          ],
          AccountSectionLabel(l10n.accountSettings),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.instance.mode,
            builder: (context, mode, _) => AccountSwitchItem(
              icon: Icons.dark_mode,
              label: l10n.accountDarkMode,
              value: mode == ThemeMode.dark,
              onChanged: ThemeController.instance.setDark,
            ),
          ),
          AccountMenuItem(
            icon: Icons.edit,
            label: l10n.accountEditProfile,
            onTap: () => _editProfile(context),
          ),
          AccountMenuItem(
            icon: Icons.lock_reset,
            label: l10n.authChangePassword,
            onTap: () => Navigator.pushNamed(context, Routes.changePassword),
          ),
          AccountMenuItem(
            icon: Icons.help,
            label: l10n.accountHelpAndSupport,
            onTap: () => _showHelp(context),
          ),
          AccountLogoutButton(
            selectorKey: 'account.logout_button',
            onTap: () => _logout(context),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
