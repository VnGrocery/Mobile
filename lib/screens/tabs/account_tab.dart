import 'package:flutter/material.dart';

import '../../data/session.dart';
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
    final name = TextEditingController(text: session.displayName);
    final email = TextEditingController(text: session.email);
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.screenBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          14,
          20,
          MediaQuery.viewInsetsOf(sheetContext).bottom + 20,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: _sheetHandle(context)),
              const SizedBox(height: 18),
              const Text(
                'Sửa hồ sơ',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Tên hiển thị',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if ((value ?? '').trim().length < 2) {
                    return 'Nhập tên tối thiểu 2 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  final text = (value ?? '').trim();
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(text)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    session.updateProfile(
                      displayName: name.text,
                      email: email.text,
                    );
                    setState(() {});
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã cập nhật hồ sơ')),
                    );
                  },
                  child: const Text('Lưu thay đổi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    name.dispose();
    email.dispose();
  }

  void _showHelp(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.screenBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _sheetHandle(context)),
            const SizedBox(height: 18),
            const Text(
              'Hỗ trợ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _helpRow(
              Icons.qr_code_scanner,
              'Quét sản phẩm',
              'Chụp sản phẩm và mã QR để kiểm tra dữ liệu đã ghi nhận.',
            ),
            _helpRow(
              Icons.storefront,
              'Cửa hàng',
              'Xem danh sách cửa hàng, đánh giá và sản phẩm gần đây.',
            ),
            _helpRow(
              Icons.mail,
              'Liên hệ',
              'Gửi email tới support@vngrocery.local khi cần hỗ trợ.',
            ),
          ],
        ),
      ),
    );
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          role == 'seller'
              ? 'Đã chuyển sang chế độ người bán'
              : 'Đã chuyển sang chế độ người mua',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;
    final isSeller = session.role == 'seller';

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text(
          'Hồ sơ cá nhân',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: widget.bottomContentInset),
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/user.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  session.displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  session.email,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                _roleSwitch(isSeller),
              ],
            ),
          ),
          _section('Chế độ hiện tại'),
          _modeCard(isSeller),
          if (isSeller) ...[
            _section('Quản lý bán hàng'),
            _item(Icons.inventory_2, 'Sản phẩm của tôi', () => _selectTab(1)),
            _item(Icons.store, 'Thông tin cửa hàng', () => _selectTab(2)),
          ] else ...[
            _section('Hoạt động mua hàng'),
            _item(Icons.explore, 'Khám phá cửa hàng', () => _selectTab(1)),
            _item(Icons.qr_code_scanner, 'Quét sản phẩm', () => _selectTab(2)),
          ],
          _section('Cài đặt'),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.instance.mode,
            builder: (context, mode, _) => _switchItem(
              Icons.dark_mode,
              'Chế độ tối',
              mode == ThemeMode.dark,
              ThemeController.instance.setDark,
            ),
          ),
          _item(Icons.edit, 'Sửa hồ sơ', () => _editProfile(context)),
          _item(
            Icons.lock_reset,
            'Đổi mật khẩu',
            () => Navigator.pushNamed(context, Routes.changePassword),
          ),
          _item(Icons.help, 'Hỗ trợ & Trợ giúp', () => _showHelp(context)),
          const SizedBox(height: 24),
          InkWell(
            onTap: () => _logout(context),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: AppColors.meatRed),
                  SizedBox(width: 8),
                  Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color: AppColors.meatRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _roleSwitch(bool isSeller) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _roleItem(
            label: 'Người mua',
            icon: Icons.person,
            selected: !isSeller,
            onTap: () => _switchRole('user'),
          ),
          _roleItem(
            label: 'Người bán',
            icon: Icons.storefront,
            selected: isSeller,
            onTap: () => _switchRole('seller'),
          ),
        ],
      ),
    );
  }

  Widget _roleItem({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? AppColors.primaryGreen : AppColors.gray,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.primaryGreen : AppColors.gray,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeCard(bool isSeller) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSeller ? Icons.storefront : Icons.person,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isSeller
                    ? 'Chế độ người bán: quản lý cửa hàng, sản phẩm và ghi nhận.'
                    : 'Chế độ người mua: khám phá, quét mã và kiểm tra sản phẩm.',
                style: const TextStyle(height: 1.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );

  Widget _item(IconData icon, String label, VoidCallback onTap) {
    final scheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: scheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(label, style: const TextStyle(fontSize: 15)),
                ),
                Icon(Icons.chevron_right, color: palette.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _switchItem(
    IconData icon,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: scheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 15)),
              ),
              Switch(
                value: value,
                activeThumbColor: AppColors.primaryGreen,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetHandle(BuildContext context) => Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: context.palette.border,
          borderRadius: BorderRadius.circular(99),
        ),
      );

  Widget _helpRow(IconData icon, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: context.palette.positiveBg,
            child: Icon(icon, size: 18, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
