import 'package:flutter/material.dart';

import '../data/session.dart';
import '../theme/app_colors.dart';
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
                const PledgeTab(),
                SellerProductListScreen(shopId: SessionManager.instance.shopId),
                const SellerShopScreen(),
                const AccountTab(),
              ]
            : [
                HomeTab(
                  onOpenMenu: () => setState(() => _menuOpen = true),
                ),
                const ExploreTab(),
                const ScannerScreen(),
                const AccountTab(),
              ];
        final destinations = isSeller
            ? const [
                NavigationDestination(
                  icon: Icon(Icons.store),
                  label: 'Tổng quan',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2),
                  label: 'Sản phẩm',
                ),
                NavigationDestination(
                  icon: Icon(Icons.storefront),
                  label: 'Cửa hàng',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_circle),
                  label: 'Tài khoản',
                ),
              ]
            : const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Trang chủ',
                ),
                NavigationDestination(
                  icon: Icon(Icons.explore),
                  label: 'Khám phá',
                ),
                NavigationDestination(
                  icon: Icon(Icons.qr_code_scanner),
                  label: 'Quét SP',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_circle),
                  label: 'Tài khoản',
                ),
              ];
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
                              index: selectedIndex, children: tabs),
                          bottomNavigationBar: NavigationBarTheme(
                            data: NavigationBarThemeData(
                              backgroundColor: Colors.white,
                              indicatorColor:
                                  AppColors.meatRed.withValues(alpha: 0.1),
                              labelTextStyle:
                                  WidgetStateProperty.resolveWith((states) {
                                final selected =
                                    states.contains(WidgetState.selected);
                                return TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: selected
                                      ? AppColors.meatRed
                                      : Colors.grey,
                                );
                              }),
                              iconTheme:
                                  WidgetStateProperty.resolveWith((states) {
                                final selected =
                                    states.contains(WidgetState.selected);
                                return IconThemeData(
                                  color: selected
                                      ? AppColors.meatRed
                                      : Colors.grey,
                                );
                              }),
                            ),
                            child: NavigationBar(
                              selectedIndex: selectedIndex,
                              onDestinationSelected: (index) => setState(() {
                                _index = index;
                                _menuOpen = false;
                              }),
                              destinations: destinations,
                            ),
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
            ],
          ),
        );
      },
    );
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
    final items = isSeller
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
            _MenuItem(Icons.account_circle, 'Tài khoản'),
          ];

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
