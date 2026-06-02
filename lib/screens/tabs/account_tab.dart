import 'package:flutter/material.dart';

import '../../core/ui/app_feedback.dart';
import '../../data/session.dart';
import '../../features/account/widgets/account_components.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_palette.dart';
import '../../theme/theme_controller.dart';

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
    final session = SessionManager.instance;
    final saved = await showAccountEditProfileSheet(
      context,
      initialName: session.displayName,
      initialEmail: session.email,
      onSave: (name, email) {
        session.updateProfile(displayName: name, email: email);
        setState(() {});
      },
    );

    if (saved == true && context.mounted) {
      AppFeedback.showSnackBar(context, 'Đã cập nhật hồ sơ');
    }
  }

  void _showHelp(BuildContext context) {
    showAccountHelpSheet(context);
  }

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: AppColors.meatRed),
            ),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      SessionManager.instance.logout();
      Navigator.pushNamedAndRemoveUntil(context, Routes.auth, (r) => false);
    }
  }

  void _switchRole(String role) {
    SessionManager.instance.setRole(role);
    setState(() {});
    AppFeedback.showSnackBar(
      context,
      role == 'seller'
          ? 'Đã chuyển sang chế độ người bán'
          : 'Đã chuyển sang chế độ người mua',
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;
    final isSeller = session.role == 'seller';

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: const Text(
          'Hồ sơ cá nhân',
          style: TextStyle(fontWeight: FontWeight.bold),
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
          const AccountSectionLabel('Chế độ hiện tại'),
          AccountModeCard(isSeller: isSeller),
          if (isSeller) ...[
            const AccountSectionLabel('Quản lý bán hàng'),
            AccountMenuItem(
              icon: Icons.inventory_2,
              label: 'Sản phẩm của tôi',
              onTap: () => _selectTab(1),
            ),
            AccountMenuItem(
              icon: Icons.store,
              label: 'Thông tin cửa hàng',
              onTap: () => _selectTab(2),
            ),
          ] else ...[
            const AccountSectionLabel('Hoạt động mua hàng'),
            AccountMenuItem(
              icon: Icons.explore,
              label: 'Khám phá cửa hàng',
              onTap: () => _selectTab(1),
            ),
            AccountMenuItem(
              icon: Icons.qr_code_scanner,
              label: 'Quét sản phẩm',
              onTap: () => _selectTab(2),
            ),
          ],
          const AccountSectionLabel('Cài đặt'),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.instance.mode,
            builder: (context, mode, _) => AccountSwitchItem(
              icon: Icons.dark_mode,
              label: 'Chế độ tối',
              value: mode == ThemeMode.dark,
              onChanged: ThemeController.instance.setDark,
            ),
          ),
          AccountMenuItem(
            icon: Icons.edit,
            label: 'Sửa hồ sơ',
            onTap: () => _editProfile(context),
          ),
          AccountMenuItem(
            icon: Icons.lock_reset,
            label: 'Đổi mật khẩu',
            onTap: () => Navigator.pushNamed(context, Routes.changePassword),
          ),
          AccountMenuItem(
            icon: Icons.help,
            label: 'Hỗ trợ & Trợ giúp',
            onTap: () => _showHelp(context),
          ),
          AccountLogoutButton(onTap: () => _logout(context)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
