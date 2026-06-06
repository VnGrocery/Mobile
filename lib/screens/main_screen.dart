import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/account/controllers/session_state.dart';
import 'package:vngrocery/features/navigation/navigation_config.dart';
import 'package:vngrocery/features/navigation/widgets/animated_content_shell.dart';
import 'package:vngrocery/features/navigation/widgets/floating_tab_popup.dart';
import 'package:vngrocery/features/navigation/widgets/side_menu_gesture_layers.dart';
import 'package:vngrocery/features/navigation/widgets/side_menu_panel.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';
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
  static const int _buyerVoucherWalletMenuIndex = 4;

  int _index = 0;
  bool _menuOpen = false;
  double _menuDragDistance = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, session) {
        final isSeller = session.isSeller;
        final tabs = _tabsForRole(session);
        final selectedIndex = _index.clamp(0, tabs.length - 1);

        return Scaffold(
          backgroundColor: context.palette.appBackground,
          body: Stack(
            children: [
              SideMenuPanel(
                isSeller: isSeller,
                open: _menuOpen,
                selectedIndex: _sideMenuSelectedIndex(
                  selectedIndex,
                  isSeller,
                ),
                onSelect: (index) => _handleSideMenuSelect(index, isSeller),
              ),
              AnimatedContentShell(
                open: _menuOpen,
                selectedIndex: selectedIndex,
                tabs: tabs,
              ),
              if (_menuOpen)
                SideMenuCloseOverlay(
                  selectorKey: 'navigation.menu_close_overlay',
                  onTap: () => setState(() => _menuOpen = false),
                  onDragUpdate: _closeMenuFromDrag,
                  onDragEnd: _resetMenuDrag,
                ),
              if (!_menuOpen)
                SideMenuOpenDragHandle(
                  selectorKey: 'navigation.menu_open_handle',
                  onDragUpdate: _openMenuFromDrag,
                  onDragEnd: _resetMenuDrag,
                ),
              if (!_menuOpen)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 8,
                  child: FloatingTabPopup(
                    items: NavigationConfig.bottomNavItems(isSeller),
                    selectedIndex: selectedIndex,
                    onSelect: _selectBottomTab,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _tabsForRole(SessionState session) {
    if (session.isSeller) {
      return [
        const PledgeTab(bottomContentInset: _bottomNavContentInset),
        SellerProductListScreen(
          shopId: session.shopId,
          bottomContentInset: _bottomNavContentInset,
        ),
        const SellerShopScreen(bottomContentInset: _bottomNavContentInset),
        AccountTab(
          bottomContentInset: _bottomNavContentInset,
          onSelectTab: _setIndex,
        ),
      ];
    }

    return [
      HomeTab(
        onOpenMenu: () => setState(() => _menuOpen = true),
        bottomContentInset: _bottomNavContentInset,
      ),
      const ExploreMapScreen(
        key: ValueKey('explore_map'),
        showBackButton: false,
        bottomOverlayInset: _bottomNavContentInset,
      ),
      const ScannerScreen(bottomContentInset: _bottomNavContentInset),
      const ExploreTab(
        key: ValueKey('store_list'),
        showMap: false,
        bottomContentInset: _bottomNavContentInset,
      ),
      AccountTab(
        bottomContentInset: _bottomNavContentInset,
        onSelectTab: _setIndex,
      ),
    ];
  }

  void _selectBottomTab(int index) {
    setState(() {
      _index = index;
      _menuOpen = false;
    });
  }

  void _handleSideMenuSelect(int index, bool isSeller) {
    if (!isSeller && index == _buyerVoucherWalletMenuIndex) {
      setState(() => _menuOpen = false);
      Navigator.pushNamed(context, Routes.voucherWallet);
      return;
    }

    final tabIndex =
        !isSeller && index > _buyerVoucherWalletMenuIndex ? index - 1 : index;
    _setIndex(tabIndex);
    setState(() => _menuOpen = false);
  }

  int _sideMenuSelectedIndex(int tabIndex, bool isSeller) {
    if (isSeller) return tabIndex;
    return tabIndex >= _buyerVoucherWalletMenuIndex ? tabIndex + 1 : tabIndex;
  }

  void _setIndex(int index) {
    setState(() => _index = index);
  }

  void _openMenuFromDrag(DragUpdateDetails details) {
    _menuDragDistance += details.primaryDelta ?? 0;
    if (_menuDragDistance > 28 && !_menuOpen) {
      setState(() {
        _menuOpen = true;
        _menuDragDistance = 0;
      });
    }
  }

  void _closeMenuFromDrag(DragUpdateDetails details) {
    _menuDragDistance += details.primaryDelta ?? 0;
    if (_menuDragDistance < -28 && _menuOpen) {
      setState(() {
        _menuOpen = false;
        _menuDragDistance = 0;
      });
    }
  }

  void _resetMenuDrag() {
    _menuDragDistance = 0;
  }
}
