import 'package:flutter/material.dart';

import '../../data/data_hooks.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';

class BuyerCheckPresenter {
  const BuyerCheckPresenter._();

  static BuyerCheckResult lastResult() {
    return AppDataHooks.instance.getLastBuyerCheck();
  }

  static Product demoProduct() {
    return AppDataHooks.instance.getProduct('p1');
  }

  static Shop shop(String shopId) {
    return AppDataHooks.instance.getShop(shopId);
  }

  static VoucherCheckResult checkVoucher({
    required String code,
    required Product product,
  }) {
    return AppDataHooks.instance.checkVoucher(
      code: code,
      shopId: product.shopId,
      orderValue: product.price,
    );
  }

  static void saveVoucherToWallet({
    required String userEmail,
    required String voucherId,
  }) {
    AppDataHooks.instance.saveVoucherToWallet(
      userEmail: userEmail,
      voucherId: voucherId,
    );
  }

  static bool isNearStore(BuyerCheckResult result) {
    return result.locationStatus == 'near';
  }

  static IconData locationIcon(BuyerCheckResult result) {
    return isNearStore(result) ? Icons.gps_fixed : Icons.gps_off;
  }

  static Color locationColor(BuyerCheckResult result) {
    return isNearStore(result) ? AppColors.trustGreen : AppColors.warningOrange;
  }

  static String locationLabel(BuyerCheckResult result) {
    return isNearStore(result) ? 'Ghi nhận tại quầy' : 'Cần thêm lượt xác nhận';
  }

  static String locationDescription(BuyerCheckResult result) {
    return isNearStore(result)
        ? 'Bạn đang ở gần cửa hàng. Ghi nhận này được tính vào dữ liệu gần đây.'
        : 'Bạn không ở gần cửa hàng. Ghi nhận này chỉ dùng để tham khảo.';
  }
}
