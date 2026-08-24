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

  const AccountTab({super.key, this.bottomContentInset = 0, this.onSelectTab});

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
      onSave: (name, email) async {
        await context.read<SessionCubit>().updateProfileRemote(
          displayName: name,
        );
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
            key: const ValueKey('account.logout_dialog.cancel_button'),
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            key: const ValueKey('account.logout_dialog.confirm_button'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.accountLogoutTitle,
              style: const TextStyle(color: AppColors.primaryGreen),
            ),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<SessionCubit>().logoutRemote();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, Routes.auth, (r) => false);
    }
  }

  void _switchSellerMode(bool sellerMode) {
    final l10n = AppLocalizations.of(context);
    context.read<SessionCubit>().setSellerMode(sellerMode);
    AppFeedback.showSnackBar(
      context,
      sellerMode
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
            canSell: session.canSell,
            onSellerModeChanged: _switchSellerMode,
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
          ],
          // A buyer section used to repeat "Explore stores" and "Scan products"
          // here, which are already the bottom nav destinations. It also broke
          // when the map tab was merged away: the hardcoded tab indexes then
          // pointed at the wrong screens.
          // The reader's own record of what they checked. Nothing but scanning
          // a product at a stall puts anything in it, so it sits with their
          // account rather than on a discovery screen.
          AccountSectionLabel(l10n.accountMyActivity),
          AccountMenuItem(
            icon: Icons.fact_check_outlined,
            label: l10n.accountMyChecks,
            onTap: () => Navigator.pushNamed(context, Routes.myChecks),
          ),
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
