import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'navigation_item.dart';

class NavigationConfig {
  const NavigationConfig._();

  static List<NavigationItem> sideMenuItems(
    AppLocalizations l10n,
    bool isSeller,
  ) {
    if (isSeller) return _sellerItems(l10n);
    return [
      NavigationItem(Icons.home, l10n.navHome, selectorKey: 'home'),
      NavigationItem(
        Icons.qr_code_scanner,
        l10n.navScanProducts,
        selectorKey: 'scan',
      ),
      NavigationItem(Icons.storefront, l10n.navStores, selectorKey: 'stores'),
      NavigationItem(
        Icons.wallet,
        l10n.navVoucherWallet,
        selectorKey: 'wallet',
      ),
      NavigationItem(
        Icons.account_circle,
        l10n.navAccount,
        selectorKey: 'account',
      ),
    ];
  }

  static List<NavigationItem> bottomNavItems(
    AppLocalizations l10n,
    bool isSeller,
  ) {
    if (isSeller) return _sellerItems(l10n);
    return [
      NavigationItem(Icons.home, l10n.navHome, selectorKey: 'home'),
      NavigationItem(
        Icons.qr_code_scanner,
        l10n.navScanProducts,
        selectorKey: 'scan',
      ),
      NavigationItem(Icons.storefront, l10n.navStores, selectorKey: 'stores'),
      NavigationItem(
        Icons.account_circle,
        l10n.navAccount,
        selectorKey: 'account',
      ),
    ];
  }

  /// The seller has the same set in both places, so it is built once.
  static List<NavigationItem> _sellerItems(AppLocalizations l10n) => [
    NavigationItem(
      Icons.store,
      l10n.navSellerOverview,
      selectorKey: 'seller_overview',
    ),
    NavigationItem(
      Icons.inventory_2,
      l10n.navSellerProducts,
      selectorKey: 'seller_products',
    ),
    NavigationItem(
      Icons.storefront,
      l10n.navSellerStore,
      selectorKey: 'seller_store',
    ),
    NavigationItem(
      Icons.account_circle,
      l10n.navAccount,
      selectorKey: 'seller_account',
    ),
  ];
}
