import 'package:flutter/material.dart';

import 'navigation_item.dart';

class NavigationConfig {
  const NavigationConfig._();

  static List<NavigationItem> sideMenuItems(bool isSeller) {
    return isSeller
        ? const [
            NavigationItem(
              Icons.store,
              'Tổng quan',
              selectorKey: 'seller_overview',
            ),
            NavigationItem(
              Icons.inventory_2,
              'Sản phẩm',
              selectorKey: 'seller_products',
            ),
            NavigationItem(
              Icons.storefront,
              'Cửa hàng',
              selectorKey: 'seller_store',
            ),
            NavigationItem(
              Icons.account_circle,
              'Tài khoản',
              selectorKey: 'seller_account',
            ),
          ]
        : const [
            NavigationItem(Icons.home, 'Trang chủ', selectorKey: 'home'),
            NavigationItem(Icons.explore, 'Khám phá', selectorKey: 'explore'),
            NavigationItem(
              Icons.qr_code_scanner,
              'Quét sản phẩm',
              selectorKey: 'scan',
            ),
            NavigationItem(
              Icons.storefront,
              'Cửa hàng',
              selectorKey: 'stores',
            ),
            NavigationItem(Icons.wallet, 'Ví voucher', selectorKey: 'wallet'),
            NavigationItem(
              Icons.account_circle,
              'Tài khoản',
              selectorKey: 'account',
            ),
          ];
  }

  static List<NavigationItem> bottomNavItems(bool isSeller) {
    return isSeller
        ? const [
            NavigationItem(
              Icons.store,
              'Tổng quan',
              selectorKey: 'seller_overview',
            ),
            NavigationItem(
              Icons.inventory_2,
              'Sản phẩm',
              selectorKey: 'seller_products',
            ),
            NavigationItem(
              Icons.storefront,
              'Cửa hàng',
              selectorKey: 'seller_store',
            ),
            NavigationItem(
              Icons.account_circle,
              'Tài khoản',
              selectorKey: 'seller_account',
            ),
          ]
        : const [
            NavigationItem(Icons.home, 'Trang chủ', selectorKey: 'home'),
            NavigationItem(Icons.explore, 'Khám phá', selectorKey: 'explore'),
            NavigationItem(
              Icons.qr_code_scanner,
              'Quét sản phẩm',
              selectorKey: 'scan',
            ),
            NavigationItem(
              Icons.storefront,
              'Cửa hàng',
              selectorKey: 'stores',
            ),
            NavigationItem(
              Icons.account_circle,
              'Tài khoản',
              selectorKey: 'account',
            ),
          ];
  }
}
