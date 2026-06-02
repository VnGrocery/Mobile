import 'package:flutter/material.dart';

import 'navigation_item.dart';

class NavigationConfig {
  const NavigationConfig._();

  static List<NavigationItem> sideMenuItems(bool isSeller) {
    return isSeller
        ? const [
            NavigationItem(Icons.store, 'Tổng quan'),
            NavigationItem(Icons.inventory_2, 'Sản phẩm'),
            NavigationItem(Icons.storefront, 'Cửa hàng'),
            NavigationItem(Icons.account_circle, 'Tài khoản'),
          ]
        : const [
            NavigationItem(Icons.home, 'Trang chủ'),
            NavigationItem(Icons.explore, 'Khám phá'),
            NavigationItem(Icons.qr_code_scanner, 'Quét sản phẩm'),
            NavigationItem(Icons.storefront, 'Cửa hàng'),
            NavigationItem(Icons.wallet, 'Ví voucher'),
            NavigationItem(Icons.account_circle, 'Tài khoản'),
          ];
  }

  static List<NavigationItem> bottomNavItems(bool isSeller) {
    return isSeller
        ? const [
            NavigationItem(Icons.store, 'Tổng quan'),
            NavigationItem(Icons.inventory_2, 'Sản phẩm'),
            NavigationItem(Icons.storefront, 'Cửa hàng'),
            NavigationItem(Icons.account_circle, 'Tài khoản'),
          ]
        : const [
            NavigationItem(Icons.home, 'Trang chủ'),
            NavigationItem(Icons.explore, 'Khám phá'),
            NavigationItem(Icons.qr_code_scanner, 'Quét sản phẩm'),
            NavigationItem(Icons.storefront, 'Cửa hàng'),
            NavigationItem(Icons.account_circle, 'Tài khoản'),
          ];
  }
}
