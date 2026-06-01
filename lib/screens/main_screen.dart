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
            : const [
                HomeTab(),
                ExploreTab(),
                ScannerScreen(),
                AccountTab(),
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
                  label: 'Quét',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_circle),
                  label: 'Tài khoản',
                ),
              ];
        final selectedIndex = _index.clamp(0, tabs.length - 1);

        return Scaffold(
          body: IndexedStack(index: selectedIndex, children: tabs),
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.white,
              indicatorColor: AppColors.meatRed.withValues(alpha: 0.1),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: selected ? AppColors.meatRed : Colors.grey,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return IconThemeData(
                  color: selected ? AppColors.meatRed : Colors.grey,
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => setState(() => _index = index),
              destinations: destinations,
            ),
          ),
        );
      },
    );
  }
}
