import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../data/session.dart';
import '../theme/app_colors.dart';
import 'explore_map_screen.dart';
import 'scanner_screen.dart';
import 'seller_product_list_screen.dart';
import 'seller_shop_screen.dart';
import 'tabs/account_tab.dart';
import 'tabs/explore_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/pledge_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const double _bottomNavContentInset = 92;

  int _index = 0;
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SessionManager.instance.roleNotifier,
      builder: (context, role, _) {
        final isSeller = role == 'seller';
        final tabs = isSeller
            ? [
                const PledgeTab(
                  bottomContentInset: _bottomNavContentInset,
                ),
                SellerProductListScreen(
                  shopId: SessionManager.instance.shopId,
                  bottomContentInset: _bottomNavContentInset,
                ),
                const SellerShopScreen(
                  bottomContentInset: _bottomNavContentInset,
                ),
                const AccountTab(
                  bottomContentInset: _bottomNavContentInset,
                ),
              ]
            : [
                HomeTab(
                  onOpenMenu: () => setState(() => _menuOpen = true),
                  bottomContentInset: _bottomNavContentInset,
                ),
                const ExploreMapScreen(
                  key: ValueKey('explore_map'),
                  showBackButton: false,
                  bottomOverlayInset: _bottomNavContentInset,
                ),
                const ScannerScreen(
                  bottomContentInset: _bottomNavContentInset,
                ),
                const ExploreTab(
                  key: ValueKey('store_list'),
                  showMap: false,
                  bottomContentInset: _bottomNavContentInset,
                ),
                const AccountTab(
                  bottomContentInset: _bottomNavContentInset,
                ),
              ];
        final navItems = _menuItems(isSeller);
        final selectedIndex = _index.clamp(0, tabs.length - 1);

        return Scaffold(
          backgroundColor: AppColors.screenBg,
          body: Stack(
            children: [
              _SideMenuPanel(
                isSeller: isSeller,
                open: _menuOpen,
                selectedIndex: selectedIndex,
                onSelect: (index) {
                  setState(() {
                    _index = index;
                    _menuOpen = false;
                  });
                },
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 360),
                curve: Curves.easeOutBack,
                offset: _menuOpen ? const Offset(0.68, 0.035) : Offset.zero,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 360),
                  curve: Curves.easeOutBack,
                  alignment: Alignment.centerLeft,
                  scale: _menuOpen ? 0.86 : 1,
                  child: AnimatedPhysicalModel(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    color: Colors.white,
                    elevation: _menuOpen ? 18 : 0,
                    shadowColor: Colors.black.withValues(alpha: 0.28),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(_menuOpen ? 30 : 0),
                    child: AbsorbPointer(
                      absorbing: _menuOpen,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_menuOpen ? 30 : 0),
                        child: Scaffold(
                          backgroundColor: AppColors.screenBg,
                          body: IndexedStack(
                            index: selectedIndex,
                            children: tabs,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_menuOpen)
                Positioned(
                  left: 252,
                  top: 24,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => setState(() => _menuOpen = false),
                  ),
                ),
              if (!_menuOpen)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -14,
                  child: _FloatingTabPopup(
                    items: navItems,
                    selectedIndex: selectedIndex,
                    onSelect: (index) => setState(() {
                      _index = index;
                      _menuOpen = false;
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  static List<_MenuItem> _menuItems(bool isSeller) {
    return isSeller
        ? const [
            _MenuItem(Icons.store, 'Tổng quan'),
            _MenuItem(Icons.inventory_2, 'Sản phẩm'),
            _MenuItem(Icons.storefront, 'Cửa hàng'),
            _MenuItem(Icons.account_circle, 'Tài khoản'),
          ]
        : const [
            _MenuItem(Icons.home, 'Trang chủ'),
            _MenuItem(Icons.explore, 'Khám phá'),
            _MenuItem(Icons.qr_code_scanner, 'Quét sản phẩm'),
            _MenuItem(Icons.storefront, 'Cửa hàng'),
            _MenuItem(Icons.account_circle, 'Tài khoản'),
          ];
  }
}

class _SideMenuPanel extends StatelessWidget {
  final bool isSeller;
  final bool open;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _SideMenuPanel({
    required this.isSeller,
    required this.open,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final name = SessionManager.instance.displayName;
    final items = _MainScreenState._menuItems(isSeller);

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
                          child: _MenuHalo(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: Image.asset(
                                      'assets/images/user.png',
                                      width: 54,
                                      height: 54,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const CircleAvatar(
                                        radius: 27,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.person,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          isSeller ? 'Người bán' : 'Người mua',
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.72),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 34),
                              for (var i = 0; i < items.length; i++) ...[
                                _MenuButton(
                                  icon: items[i].icon,
                                  label: items[i].label,
                                  open: open,
                                  delayIndex: i,
                                  selected: i == selectedIndex,
                                  onTap: () => onSelect(i),
                                ),
                                const SizedBox(height: 8),
                              ],
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.13),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.receipt_long,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Dữ liệu từ quầy hàng và cộng đồng',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.82),
                                          fontSize: 12,
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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

class _MenuItem {
  final IconData icon;
  final String label;

  const _MenuItem(this.icon, this.label);
}

class _FloatingTabPopup extends StatelessWidget {
  final List<_MenuItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _FloatingTabPopup({
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final centerIndex = _centerIndex;
    final sideItems = [
      for (var i = 0; i < items.length; i++)
        if (i != centerIndex) i,
    ];
    final leftItems = sideItems.take(2).toList();
    final rightItems = sideItems.skip(2).toList();
    final centerItem = items[centerIndex];

    return SafeArea(
      top: false,
      child: Center(
        child: SizedBox(
          width: 342,
          height: 92,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.78),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 28,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 68,
                        child: Row(
                          children: [
                            const SizedBox(width: 18),
                            for (final i in leftItems)
                              Expanded(
                                child: _GlassTabItem(
                                  icon: items[i].icon,
                                  label: items[i].label,
                                  selected: i == selectedIndex,
                                  onTap: () => onSelect(i),
                                ),
                              ),
                            const SizedBox(width: 64),
                            for (final i in rightItems)
                              Expanded(
                                child: _GlassTabItem(
                                  icon: items[i].icon,
                                  label: items[i].label,
                                  selected: i == selectedIndex,
                                  onTap: () => onSelect(i),
                                ),
                              ),
                            const SizedBox(width: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: _ScanDiamondButton(
                  icon: centerItem.icon,
                  selected: centerIndex == selectedIndex,
                  onTap: () => onSelect(centerIndex),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int get _centerIndex {
    final scan = items.indexWhere((item) =>
        item.icon == Icons.qr_code_scanner || item.label.contains('Quét'));
    if (scan >= 0) return scan;
    return items.length > 1 ? 1 : 0;
  }
}

class _ScanDiamondButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ScanDiamondButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        onTap: onTap,
        child: Transform.rotate(
          angle: 0.785398,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryGreenDark
                  : AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.34),
                  blurRadius: 34,
                  spreadRadius: 4,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Transform.rotate(
              angle: -0.785398,
              child: Icon(
                icon,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GlassTabItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  selected ? AppColors.primaryGreen : const Color(0xFF8BA1B2),
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              _shortLabel(label),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color:
                    selected ? AppColors.primaryGreen : const Color(0xFF8BA1B2),
                fontSize: 10.5,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _shortLabel(String value) {
    if (value == 'Quét sản phẩm') return 'Quét';
    return value;
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool open;
  final int delayIndex;
  final bool selected;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.open,
    required this.delayIndex,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final delay = Duration(milliseconds: 40 * delayIndex);
    return AnimatedSlide(
      duration: Duration(milliseconds: 260 + 24 * delayIndex),
      curve: Curves.easeOutCubic,
      offset: open ? Offset.zero : const Offset(-0.16, 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220) + delay,
        curve: Curves.easeOutCubic,
        opacity: open ? 1 : 0,
        child: Material(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: selected ? AppColors.primaryGreen : Colors.white,
                    size: 21,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected ? AppColors.primaryGreen : Colors.white,
                        fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuHalo extends StatelessWidget {
  const _MenuHalo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.10),
      ),
    );
  }
}
