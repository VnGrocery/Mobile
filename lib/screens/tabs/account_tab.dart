import 'package:flutter/material.dart';

import '../../data/session.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';

class AccountTab extends StatefulWidget {
  final double bottomContentInset;

  const AccountTab({super.key, this.bottomContentInset = 0});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  void _notImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang được phát triển')),
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
                      decoration: const BoxDecoration(
                        color: AppColors.card,
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
            _item(
              Icons.inventory_2,
              'Sản phẩm của tôi',
              () => Navigator.pushNamed(
                context,
                Routes.sellerProducts,
                arguments: session.shopId,
              ),
            ),
            _item(
              Icons.store,
              'Thông tin cửa hàng',
              () => Navigator.pushNamed(context, Routes.sellerShop),
            ),
          ] else ...[
            _section('Hoạt động mua hàng'),
            _item(
              Icons.explore,
              'Khám phá cửa hàng',
              () => DefaultTabController.maybeOf(context),
            ),
            _item(
              Icons.qr_code_scanner,
              'Quét sản phẩm',
              () => Navigator.pushNamed(context, Routes.scan),
            ),
          ],
          _section('Cài đặt'),
          _item(Icons.edit, 'Sửa hồ sơ', () => _notImplemented(context)),
          _item(
            Icons.lock_reset,
            'Đổi mật khẩu',
            () => Navigator.pushNamed(context, Routes.changePassword),
          ),
          _item(
              Icons.help, 'Hỗ trợ & Trợ giúp', () => _notImplemented(context)),
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
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.card,
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
            color: selected ? Colors.white : Colors.transparent,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: AppColors.card,
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
                const Icon(Icons.chevron_right, color: Color(0xFFD3D3D3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
